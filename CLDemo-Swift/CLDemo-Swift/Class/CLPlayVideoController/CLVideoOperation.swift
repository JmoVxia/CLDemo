//
//  CLVideoOperation.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit
import AVFoundation

class CLVideoOperation: Operation {
    var imageCallback: ((CGImage, String) -> ())?
    private var path: String!
    private var taskFinished: Bool = true {
        willSet {
            if taskFinished != newValue {
                willChangeValue(forKey: "isFinished")
            }
        }
        didSet {
            if taskFinished != oldValue {
                didChangeValue(forKey: "isFinished")
            }
        }
    }
    private var taskExecuting: Bool = false {
        willSet {
            if taskExecuting != newValue {
                willChangeValue(forKey: "isExecuting")
            }
        }
        didSet {
            if taskExecuting != oldValue {
                didChangeValue(forKey: "isExecuting")
            }
        }
    }
    override var isFinished: Bool {
        return taskFinished
    }
    override var isExecuting: Bool {
        return taskExecuting
    }
    override var isAsynchronous: Bool {
        return true
    }
    init(path: String, imageCallback: @escaping ((CGImage, String) -> ())) {
        self.path = path
        self.imageCallback = imageCallback
        super.init()
    }
    deinit {
//        CLLog("CLVideoOperation deinit")
    }
}
extension CLVideoOperation {
    override func start() {
        autoreleasepool {
            if isCancelled {
                taskFinished = true
                taskExecuting = false
            }else {
                taskFinished = false
                taskExecuting = true
                startTask {
                    taskFinished = true
                    taskExecuting = false
                }
            }
        }
    }
    override func cancel() {
        if (isExecuting) {
            taskFinished = true
            taskExecuting = false
        }
        super.cancel()
    }
}
extension CLVideoOperation {
    private func startTask(_ complete: (() -> ())) {
        defer {
            complete()
        }
        let url = URL(fileURLWithPath: path)
        let asset = AVURLAsset(url: url, options: nil)
        let videoTracks = asset.tracks(withMediaType: .video)
        guard !videoTracks.isEmpty,
              let assetReader = try? AVAssetReader(asset: asset),
              let videoTrack = videoTracks.first
        else {
            return
        }
        let orientation = orientation(from: videoTrack)
        let videoReaderTrackOptput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA])
        
        assetReader.add(videoReaderTrackOptput)
        assetReader.startReading()

        let timePerFrame = 1.0 / videoTrack.nominalFrameRate
        while assetReader.status == .reading, videoTrack.nominalFrameRate > 0, !isCancelled {
            guard let sampleBuffer = videoReaderTrackOptput.copyNextSampleBuffer(),
                  let image = image(from: sampleBuffer, orientation: orientation)
            else {
                break
            }
            DispatchQueue.main.async {
                self.imageCallback?(image, self.path)
            }
            Thread.sleep(forTimeInterval: TimeInterval(timePerFrame))
        }
        assetReader.cancelReading()
    }
}
extension CLVideoOperation {
    private func image(from sampleBuffer: CMSampleBuffer, orientation: UIImage.Orientation) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }
        guard let cgImage = context.makeImage() else { return nil }
        if orientation == .up {
            return cgImage
        }else {
            return fixImage(cgImage, orientation: orientation)
        }
    }
    private func orientation(from videoTrack: AVAssetTrack) -> UIImage.Orientation {
        var orientation: UIImage.Orientation = .up
        let track = videoTrack.preferredTransform
        if track.a == 0 && track.b == 1.0 && track.c == -1.0 && track.d == 0 {
            orientation = .right
        } else if track.a == 0 && track.b == -1.0 && track.c == 1.0 && track.d == 0 {
            orientation = .left
        } else if track.a == 1.0 && track.b == 0 && track.c == 0 && track.d == 1.0 {
            orientation = .up
        } else if track.a == -1.0 && track.b == 0 && track.c == 0 && track.d == -1.0 {
            orientation = .down
        }
        return orientation
    }
    private func fixImage(_ image: CGImage, orientation: UIImage.Orientation) -> CGImage {
        var rect: CGRect
        var rotate: CGFloat = 0
        var translateX: CGFloat = 0
        var translateY: CGFloat = 0
        var scaleX: CGFloat = 1.0
        var scaleY: CGFloat = 1.0

        let size = CGSize(width: CGFloat(image.width), height: CGFloat(image.height))
        switch orientation {
            case .left:
                rotate = .pi * 0.5
                rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
                translateX = 0
                translateY = -rect.width
                scaleY = rect.width / rect.height
                scaleX = rect.height / rect.width
            case .right:
                rotate = 1.5 * .pi
                rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
                translateX = -rect.height
                translateY = 0
                scaleY = rect.width / rect.height
                scaleX = rect.height / rect.width
            case .down:
                rotate = .pi
                rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                translateX = -rect.width
                translateY = -rect.height
            default:
                rotate = 0.0
                rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                translateX = 0
                translateY = 0
        }
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0.0, y: rect.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.rotate(by: CGFloat(rotate))
        context?.translateBy(x: CGFloat(translateX), y: CGFloat(translateY))
        context?.scaleBy(x: CGFloat(scaleX), y: CGFloat(scaleY))
        context?.draw(image, in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        let cgImage = context?.makeImage()
        UIGraphicsEndImageContext()
        if let cgImage = cgImage {
            return cgImage
        }else {
            return image
        }
    }
}
