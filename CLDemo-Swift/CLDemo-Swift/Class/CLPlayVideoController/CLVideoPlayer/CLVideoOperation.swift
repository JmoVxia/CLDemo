//
//  CLVideoOperation.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import AVFoundation
import UIKit

class CLVideoOperation: Operation, @unchecked Sendable {
    weak var bindView: UIView?
    private let videoURL: URL
    private let maximumLoopCount: Int
    private var currentLoopCount: Int = 0
    private var currentFrameIndex: Int = 0
    private var decodedFrameCount: Int?
    private let frameCache = CLVideoFrameCache.shared

    // 缓存视频元数据，避免每次循环重复读取
    private var cachedFrameRate: Float?
    private var cachedOrientation: UIImage.Orientation?
    private var cachedTimePerFrame: Float?

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
        taskFinished
    }

    override var isExecuting: Bool {
        taskExecuting
    }

    override var isAsynchronous: Bool {
        true
    }

    init(url: URL, bindTo view: UIView, loopCount: Int = 0) {
        videoURL = url
        maximumLoopCount = loopCount
        bindView = view
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
            } else {
                taskFinished = false
                taskExecuting = true
                startTask {
                    taskFinished = true
                    taskExecuting = false
                }
            }
        }
    }
}

extension CLVideoOperation {
    private func startTask(_ complete: () -> Void) {
        defer {
            complete()
        }

        // 每次任务开始时重置帧索引和循环计数
        currentFrameIndex = 0
        currentLoopCount = 0

        CLVideoFrameCacheLog.log("视频播放开始: \(videoURL.absoluteString)", level: .info)

        // 预获取视频元数据，避免每次循环重复读取
        let asset = AVURLAsset(url: videoURL, options: nil)
        let videoTracks = asset.tracks(withMediaType: .video)

        guard !videoTracks.isEmpty,
              let videoTrack = videoTracks.first,
              videoTrack.nominalFrameRate > 0
        else {
            return
        }

        let frameRate = videoTrack.nominalFrameRate
        let timePerFrame = 1.0 / frameRate
        let videoOrientation = orientation(from: videoTrack)

        // 缓存元数据
        cachedFrameRate = frameRate
        cachedTimePerFrame = timePerFrame
        cachedOrientation = videoOrientation

        while !isCancelled {
            if maximumLoopCount > 0, currentLoopCount >= maximumLoopCount {
                break
            }
            autoreleasepool {
                playOnce(asset: asset, videoTrack: videoTrack, orientation: videoOrientation, timePerFrame: timePerFrame, frameRate: frameRate)
            }
            currentLoopCount += 1
            currentFrameIndex = 0
        }
    }

    private func playOnce(asset: AVURLAsset, videoTrack: AVAssetTrack, orientation: UIImage.Orientation, timePerFrame: Float, frameRate: Float) {
        currentFrameIndex = 0

        // 后续循环且帧数已知，直接从缓存播放
        if let decodedFrameCount, currentLoopCount > 0 {
            playCachedFrames(frameCount: decodedFrameCount, frameRate: frameRate, timePerFrame: timePerFrame)
            return
        }

        guard let assetReader = try? AVAssetReader(asset: asset) else {
            return
        }

        let output = AVAssetReaderTrackOutput(
            track: videoTrack,
            outputSettings: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            ]
        )

        assetReader.add(output)
        assetReader.startReading()

        defer {
            assetReader.cancelReading()
        }

        var lastFrameTime = CACurrentMediaTime()
        let frameInterval = TimeInterval(timePerFrame)

        while assetReader.status == .reading, !isCancelled {
            let cacheKey = CLVideoFrameCache.cacheKey(videoURL: videoURL, frameIndex: currentFrameIndex, frameRate: frameRate)

            let hasFrame = playFrameWithCache(
                cacheKey: cacheKey,
                output: output,
                orientation: orientation,
                lastFrameTime: &lastFrameTime,
                frameInterval: frameInterval
            )

            if hasFrame {
                if currentLoopCount == 0 {
                    decodedFrameCount = max(decodedFrameCount ?? 0, currentFrameIndex + 1)
                }
                currentFrameIndex += 1
            } else {
                break
            }
        }
    }

    // 纯缓存播放：后续循环直接从缓存读取帧，无需创建 AVAssetReader
    private func playCachedFrames(frameCount: Int, frameRate: Float, timePerFrame: Float) {
        var lastFrameTime = CACurrentMediaTime()
        let frameInterval = TimeInterval(timePerFrame)

        for frameIndex in 0 ..< frameCount {
            if isCancelled { break }

            let cacheKey = CLVideoFrameCache.cacheKey(videoURL: videoURL, frameIndex: frameIndex, frameRate: frameRate)

            // 优先从内存缓存获取
            if let cachedImage = frameCache.memoryCacheImageForKey(cacheKey) {
                displayFrame(cachedImage, lastFrameTime: &lastFrameTime, frameInterval: frameInterval)
            } else {
                // 内存未命中则查询磁盘缓存
                let semaphore = DispatchSemaphore(value: 0)
                var frameImage: CGImage?

                frameCache.queryImageForKey(cacheKey) { image in
                    frameImage = image
                    semaphore.signal()
                }
                semaphore.wait()

                if let frameImage {
                    displayFrame(frameImage, lastFrameTime: &lastFrameTime, frameInterval: frameInterval)
                }
            }

            currentFrameIndex = frameIndex
        }
    }

    // 显示帧并精确控制帧率
    private func displayFrame(_ image: CGImage, lastFrameTime: inout CFTimeInterval, frameInterval: TimeInterval) {
        DispatchQueue.main.async {
            self.bindView?.layer.contents = image
        }

        // 精确帧率控制：计算下一帧应该显示的时间
        let targetTime = lastFrameTime + frameInterval
        let now = CACurrentMediaTime()
        let sleepTime = targetTime - now

        if sleepTime > 0 {
            Thread.sleep(forTimeInterval: sleepTime)
        }

        lastFrameTime = CACurrentMediaTime()
    }

    // 边缓存边播放：检查缓存，未命中则解码并缓存
    private func playFrameWithCache(cacheKey: String, output: AVAssetReaderTrackOutput, orientation: UIImage.Orientation, lastFrameTime: inout CFTimeInterval, frameInterval: TimeInterval) -> Bool {
        guard let sampleBuffer = output.copyNextSampleBuffer() else {
            return false
        }

        var frameImage: CGImage?

        if let cachedImage = frameCache.memoryCacheImageForKey(cacheKey) {
            frameImage = cachedImage
        } else {
            let semaphore = DispatchSemaphore(value: 0)
            frameCache.queryImageForKey(cacheKey) { [weak self] cachedImage in
                guard let self else {
                    semaphore.signal()
                    return
                }
                if let cachedImage {
                    frameImage = cachedImage
                } else if let decodedImage = image(from: sampleBuffer, orientation: orientation) {
                    frameImage = decodedImage
                    frameCache.storeImage(decodedImage, forKey: cacheKey)
                } else {
                    frameImage = nil
                }
                semaphore.signal()
            }
            semaphore.wait()
        }

        if let frameImage {
            displayFrame(frameImage, lastFrameTime: &lastFrameTime, frameInterval: frameInterval)
            return true
        } else {
            return false
        }
    }

    // 先缓存所有帧再播放
    private func precacheAllFrames() {
        CLVideoFrameCacheLog.log("开始预缓存所有帧: \(videoURL.absoluteString)", level: .info)

        let asset = AVURLAsset(url: videoURL, options: nil)
        let videoTracks = asset.tracks(withMediaType: .video)

        guard !videoTracks.isEmpty,
              let assetReader = try? AVAssetReader(asset: asset),
              let videoTrack = videoTracks.first,
              videoTrack.nominalFrameRate > 0
        else {
            return
        }

        let orientation = orientation(from: videoTrack)
        let output = AVAssetReaderTrackOutput(
            track: videoTrack,
            outputSettings: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            ]
        )

        assetReader.add(output)
        assetReader.startReading()

        var frameIndex = 0
        while assetReader.status == .reading, !isCancelled {
            guard let sampleBuffer = output.copyNextSampleBuffer(),
                  let decodedImage = image(from: sampleBuffer, orientation: orientation)
            else {
                break
            }

            let cacheKey = CLVideoFrameCache.cacheKey(videoURL: videoURL, frameIndex: frameIndex, frameRate: videoTrack.nominalFrameRate)

            // 检查是否已缓存
            let semaphore = DispatchSemaphore(value: 0)
            var alreadyCached = false

            frameCache.queryImageForKey(cacheKey) { cachedImage in
                alreadyCached = (cachedImage != nil)
                semaphore.signal()
            }

            semaphore.wait()

            if !alreadyCached {
                frameCache.storeImage(decodedImage, forKey: cacheKey)
            }

            frameIndex += 1

            if frameIndex % 10 == 0 {
                CLVideoFrameCacheLog.log("预缓存进度: \(frameIndex) 帧", level: .info)
            }
        }

        assetReader.cancelReading()
        CLVideoFrameCacheLog.log("预缓存完成: 共 \(frameIndex) 帧", level: .info)
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
        } else {
            return fixedImage(cgImage, orientation: orientation)
        }
    }

    private func orientation(from videoTrack: AVAssetTrack) -> UIImage.Orientation {
        var orientation: UIImage.Orientation = .up
        let track = videoTrack.preferredTransform
        if track.a == 0, track.b == 1.0, track.c == -1.0, track.d == 0 {
            orientation = .right
        } else if track.a == 0, track.b == -1.0, track.c == 1.0, track.d == 0 {
            orientation = .left
        } else if track.a == 1.0, track.b == 0, track.c == 0, track.d == 1.0 {
            orientation = .up
        } else if track.a == -1.0, track.b == 0, track.c == 0, track.d == -1.0 {
            orientation = .down
        }
        return orientation
    }

    private func fixedImage(_ image: CGImage, orientation: UIImage.Orientation) -> CGImage {
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

        if #available(iOS 17.0, *) {
            let renderer = UIGraphicsImageRenderer(size: rect.size)
            let uiImage = renderer.image { ctx in
                let context = ctx.cgContext
                context.translateBy(x: 0.0, y: rect.height)
                context.scaleBy(x: 1.0, y: -1.0)
                context.rotate(by: rotate)
                context.translateBy(x: translateX, y: translateY)
                context.scaleBy(x: scaleX, y: scaleY)
                context.draw(image, in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            }
            return uiImage.cgImage ?? image
        } else {
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context?.translateBy(x: 0.0, y: rect.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            context?.rotate(by: rotate)
            context?.translateBy(x: translateX, y: translateY)
            context?.scaleBy(x: scaleX, y: scaleY)
            context?.draw(image, in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            let cgImage = context?.makeImage()
            UIGraphicsEndImageContext()
            if let cgImage {
                return cgImage
            } else {
                return image
            }
        }
    }
}
