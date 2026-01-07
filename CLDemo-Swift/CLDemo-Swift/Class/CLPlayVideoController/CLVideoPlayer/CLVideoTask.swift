//
//  CLVideoTask.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import AVFoundation
import UIKit

// MARK: - 任务状态枚举

@objc enum CLVideoTaskState: Int {
    case idle
    case waiting
    case executing
    case suspended
    case finished
    case cancelled

    var isFinal: Bool {
        self == .finished || self == .cancelled
    }
}

// MARK: - CLVideoTask

final class CLVideoTask: NSObject, @unchecked Sendable {
    // MARK: - 公开属性

    let url: URL
    let maximumLoopCount: Int

    var bindViews: [UIView] {
        lock.lock()
        defer { lock.unlock() }
        return bindViewsTable.allObjects
    }

    var isCancelled: Bool { state == .cancelled }
    var isExecuting: Bool { state == .executing }
    var isFinished: Bool { state == .finished }

    // MARK: - 状态回调

    var stateDidChange: (() -> Void)?

    private(set) var state: CLVideoTaskState = .idle {
        didSet {
            guard state != oldValue else { return }
            stateDidChange?()
        }
    }

    // MARK: - 私有属性

    private let bindViewsTable = NSHashTable<UIView>.weakObjects()
    private let lock = NSRecursiveLock()
    private var currentLoopCount = 0
    private var currentFrameIndex = 0
    private var decodedFrameCount: Int?
    private lazy var frameCache = CLVideoFrameCache.shared

    private var cachedFrameRate: Float?
    private var cachedOrientation: UIImage.Orientation?
    private var cachedTimePerFrame: Float?
    private var executionThread: Thread?

    // MARK: - 初始化

    init(url: URL, loopCount: Int = 0) {
        self.url = url
        maximumLoopCount = loopCount
        super.init()
    }

    deinit {
        CLLog("CLVideoTask deinit: \(url.lastPathComponent)")
    }
}

// MARK: - 绑定视图管理

extension CLVideoTask {
    /// 添加绑定视图
    func addBindView(_ view: UIView) {
        lock.withLock { bindViewsTable.add(view) }
    }

    /// 移除绑定视图
    func removeBindView(_ view: UIView) {
        lock.lock()
        bindViewsTable.remove(view)
        DispatchQueue.main.async {
            view.layer.contents = nil
        }
        let hasViews = bindViewsTable.count > 0
        lock.unlock()

        if !hasViews {
            cancel()
        }
    }
}

// MARK: - 状态控制

extension CLVideoTask {
    /// 设置任务为等待状态
    func setWaitingState() {
        lock.lock()
        guard state == .idle else {
            lock.unlock()
            return
        }
        state = .waiting
        lock.unlock()
    }

    /// 启动任务
    func start() {
        lock.lock()
        guard state == .waiting else {
            lock.unlock()
            return
        }
        state = .executing
        lock.unlock()

        DispatchQueue.global(qos: .userInitiated).async {
            self.executeTask()
        }
    }

    /// 取消任务
    func cancel() {
        lock.lock()
        guard !state.isFinal else {
            lock.unlock()
            return
        }
        state = .cancelled
        lock.unlock()
        clearBindViewUrls()
    }

    /// 暂停任务
    func suspend() {
        lock.lock()
        guard state == .executing else {
            lock.unlock()
            return
        }
        state = .suspended
        lock.unlock()
    }

    /// 恢复任务
    func resume() {
        lock.lock()
        guard state == .suspended else {
            lock.unlock()
            return
        }
        state = .executing
        lock.unlock()
    }
}

// MARK: - 私有方法

extension CLVideoTask {
    /// 等待暂停状态结束，返回是否应继续执行
    @discardableResult
    private func waitIfSuspended() -> Bool {
        while state == .suspended, !isCancelled {
            Thread.sleep(forTimeInterval: 0.1)
        }
        return !isCancelled
    }

    private func clearBindViewUrls() {
        let views = bindViews
        DispatchQueue.main.async {
            views.forEach { $0.cl.videoURL = nil }
        }
    }

    private func setStateFinished() {
        lock.lock()
        guard !state.isFinal else {
            lock.unlock()
            return
        }
        state = .finished
        lock.unlock()
        clearBindViewUrls()
    }
}

// MARK: - 任务执行

extension CLVideoTask {
    private func executeTask() {
        defer {
            if !isCancelled {
                setStateFinished()
            }
        }

        currentFrameIndex = 0
        currentLoopCount = 0

        let asset = AVURLAsset(url: url, options: nil)
        let videoTracks = asset.tracks(withMediaType: .video)

        guard let videoTrack = videoTracks.first,
              videoTrack.nominalFrameRate > 0
        else { return }

        let frameRate = videoTrack.nominalFrameRate
        let timePerFrame = 1.0 / frameRate
        let videoOrientation = orientation(from: videoTrack)

        cachedFrameRate = frameRate
        cachedTimePerFrame = timePerFrame
        cachedOrientation = videoOrientation

        while !isCancelled {
            guard waitIfSuspended() else { break }
            if maximumLoopCount > 0, currentLoopCount >= maximumLoopCount { break }

            autoreleasepool {
                playOnce(asset: asset, videoTrack: videoTrack, orientation: videoOrientation, timePerFrame: timePerFrame, frameRate: frameRate)
            }

            currentLoopCount += 1
            currentFrameIndex = 0
        }
    }

    private func playOnce(asset: AVURLAsset, videoTrack: AVAssetTrack, orientation: UIImage.Orientation, timePerFrame: Float, frameRate: Float) {
        currentFrameIndex = 0

        if let decodedFrameCount, currentLoopCount > 0 {
            playCachedFrames(frameCount: decodedFrameCount, frameRate: frameRate, timePerFrame: timePerFrame)
            return
        }

        guard let assetReader = try? AVAssetReader(asset: asset) else { return }

        let output = AVAssetReaderTrackOutput(
            track: videoTrack,
            outputSettings: [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        )

        assetReader.add(output)
        assetReader.startReading()
        defer { assetReader.cancelReading() }

        var lastFrameTime = CACurrentMediaTime()
        let frameInterval = TimeInterval(timePerFrame)

        while assetReader.status == .reading, !isCancelled {
            guard waitIfSuspended() else { break }

            let cacheKey = CLVideoFrameCache.cacheKey(videoURL: url, frameIndex: currentFrameIndex, frameRate: frameRate)

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

    private func playCachedFrames(frameCount: Int, frameRate: Float, timePerFrame: Float) {
        var lastFrameTime = CACurrentMediaTime()
        let frameInterval = TimeInterval(timePerFrame)

        for frameIndex in 0 ..< frameCount {
            guard waitIfSuspended() else { break }

            let cacheKey = CLVideoFrameCache.cacheKey(videoURL: url, frameIndex: frameIndex, frameRate: frameRate)

            if let cachedImage = frameCache.memoryCacheImageForKey(cacheKey) {
                displayFrame(cachedImage, lastFrameTime: &lastFrameTime, frameInterval: frameInterval)
            } else {
                let semaphore = DispatchSemaphore(value: 0)
                var frameImage: CGImage?

                frameCache.queryImageForKey(cacheKey) { image in
                    frameImage = image
                    semaphore.signal()
                }

                let waitResult = semaphore.wait(timeout: .now() + 0.5)
                if waitResult == .timedOut || isCancelled { break }

                if let frameImage {
                    displayFrame(frameImage, lastFrameTime: &lastFrameTime, frameInterval: frameInterval)
                }
            }

            currentFrameIndex = frameIndex
        }
    }

    private func displayFrame(_ image: CGImage, lastFrameTime: inout CFTimeInterval, frameInterval: TimeInterval) {
        let currentURL = url
        let views = bindViews

        DispatchQueue.main.async {
            views.filter { $0.cl.videoURL == currentURL }.forEach { $0.layer.contents = image }
        }

        let targetTime = lastFrameTime + frameInterval
        let sleepTime = targetTime - CACurrentMediaTime()
        if sleepTime > 0 {
            Thread.sleep(forTimeInterval: sleepTime)
        }
        lastFrameTime = CACurrentMediaTime()
    }

    private func playFrameWithCache(cacheKey: String, output: AVAssetReaderTrackOutput, orientation: UIImage.Orientation, lastFrameTime: inout CFTimeInterval, frameInterval: TimeInterval) -> Bool {
        guard let sampleBuffer = output.copyNextSampleBuffer() else { return false }

        var frameImage: CGImage?

        if let cachedImage = frameCache.memoryCacheImageForKey(cacheKey) {
            frameImage = cachedImage
        } else {
            let semaphore = DispatchSemaphore(value: 0)
            frameCache.queryImageForKey(cacheKey) { cachedImage in
                if let cachedImage {
                    frameImage = cachedImage
                } else if let decodedImage = self.image(from: sampleBuffer, orientation: orientation) {
                    frameImage = decodedImage
                    self.frameCache.storeImage(decodedImage, forKey: cacheKey)
                }
                semaphore.signal()
            }

            let waitResult = semaphore.wait(timeout: .now() + 0.5)
            if waitResult == .timedOut || isCancelled { return false }
        }

        if let frameImage {
            displayFrame(frameImage, lastFrameTime: &lastFrameTime, frameInterval: frameInterval)
            return true
        }
        return false
    }
}

// MARK: - 图像处理

extension CLVideoTask {
    private func image(from sampleBuffer: CMSampleBuffer, orientation: UIImage.Orientation) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        defer { CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0)) }

        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)

        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue),
              let cgImage = context.makeImage()
        else { return nil }

        return orientation == .up ? cgImage : fixedImage(cgImage, orientation: orientation)
    }

    private func orientation(from videoTrack: AVAssetTrack) -> UIImage.Orientation {
        let track = videoTrack.preferredTransform
        if track.a == 0, track.b == 1.0, track.c == -1.0, track.d == 0 {
            return .right
        } else if track.a == 0, track.b == -1.0, track.c == 1.0, track.d == 0 {
            return .left
        } else if track.a == -1.0, track.b == 0, track.c == 0, track.d == -1.0 {
            return .down
        }
        return .up
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
            defer { UIGraphicsEndImageContext() }
            let context = UIGraphicsGetCurrentContext()
            context?.translateBy(x: 0.0, y: rect.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            context?.rotate(by: rotate)
            context?.translateBy(x: translateX, y: translateY)
            context?.scaleBy(x: scaleX, y: scaleY)
            context?.draw(image, in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            return context?.makeImage() ?? image
        }
    }
}
