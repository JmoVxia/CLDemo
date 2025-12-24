//
//  CLVideoPlayer.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

private extension UIView {
    struct AssociatedKeys {
        static var videoURL: UInt8 = 0
        static var debounceIntervalKey: UInt8 = 1
    }

    var url: URL? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.videoURL) as? URL }
        set { objc_setAssociatedObject(self, &AssociatedKeys.videoURL, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

class CLVideoPlayer: NSObject {
    private static var manager: CLVideoPlayer?
    private static let lock = NSLock()

    private var operations = [URL: CLVideoOperation]()

    private class var shared: CLVideoPlayer {
        guard let shareManager = manager else {
            manager = CLVideoPlayer()
            return manager!
        }
        return shareManager
    }

    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        return queue
    }()

    override private init() {
        CLVideoFrameCacheLog.defaultConfig()
    }

    deinit {
        CLLog("CLVideoPlayer deinit")
    }
}

extension CLVideoPlayer {
    static func play(_ url: URL, bindTo view: UIView) {
        withLock {
            if let oldURL = view.url {
                cancelOperation(oldURL)
            }

            view.url = url

            if let operation = shared.operations[url], operation.bindView !== view {
                let oldView = operation.bindView
                oldView?.layer.contents = nil
                oldView?.url = nil
                operation.bindView = view
                view.layer.contents = nil
            } else {
                let videoOperation = CLVideoOperation(url: url, bindTo: view)
                videoOperation.completionBlock = { [weak manager] in
                    guard let manager else { return }
                    withLock {
                        manager.operations.removeValue(forKey: url)
                    }
                }
                shared.operations[url] = videoOperation
                shared.operationQueue.addOperation(videoOperation)

                CLVideoFrameCacheLog.log("播放器启动视频: \(url.absoluteString)", level: .info)
            }
        }
    }

    static func cancel(_ url: URL) {
        withLock {
            cancelOperation(url)
            CLVideoFrameCacheLog.log("播放器取消视频: \(url.absoluteString)", level: .info)
        }
    }

    static func cancelAll() {
        withLock {
            cancelAllOperations()
            CLVideoFrameCacheLog.log("播放器取消所有视频", level: .info)
        }
    }

    static func destroy() {
        withLock {
            cancelAllOperations()
            manager = nil
            CLVideoFrameCacheLog.log("播放器销毁", level: .info)
        }
    }

    // 清空缓存
    static func clearCache(completion: (() -> Void)? = nil) {
        CLVideoFrameCache.shared.clearAll(completion: completion)
    }

    // 获取缓存大小
    static func getCacheSize(completion: @escaping (Int, Int) -> Void) {
        CLVideoFrameCache.shared.getCacheSize(completion: completion)
    }

    // 获取缓存统计信息
    static func getCacheStatistics() {
        CLVideoFrameCache.shared.getStatistics()
    }
}

extension CLVideoPlayer {
    private static func cancelOperation(_ url: URL) {
        guard let operation = shared.operations[url], !operation.isCancelled else { return }
        operation.bindView = nil
        operation.completionBlock = nil
        operation.cancel()
        shared.operations.removeValue(forKey: url)
    }

    private static func cancelAllOperations() {
        shared.operationQueue.cancelAllOperations()
        shared.operations.removeAll()
    }

    private static func withLock(_ block: () -> Void) {
        lock.lock()
        defer { lock.unlock() }
        return block()
    }
}
