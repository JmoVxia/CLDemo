//
//  CLVideoPlayer.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

// MARK: - CLVideoPlayer

final class CLVideoPlayer: NSObject {
    private static var manager: CLVideoPlayer?
    private static let lock = NSRecursiveLock()

    private static var shared: CLVideoPlayer {
        lock.withLock {
            if manager == nil { manager = CLVideoPlayer() }
            return manager!
        }
    }

    private lazy var taskQueue = CLVideoTaskQueue()

    override private init() {
        super.init()
        CLVideoFrameCacheLog.defaultConfig()
    }

    deinit {
        CLLog("CLVideoPlayer deinit")
    }
}

// MARK: - 公开 API

extension CLVideoPlayer {
    /// 播放视频
    /// - Parameters:
    ///   - url: 视频 URL
    ///   - view: 绑定的视图
    static func play(_ url: URL, bindTo view: UIView) {
        lock.withLock {
            if let oldURL = view.cl.videoURL, oldURL != url {
                cancelForViewInternal(view, oldURL: oldURL)
            }

            view.cl.videoURL = url

            if let existingTask = shared.taskQueue.task(for: url) {
                existingTask.addBindView(view)
                view.layer.contents = nil
            } else {
                let task = CLVideoTask(url: url)
                task.addBindView(view)
                shared.taskQueue.addTask(task)
                view.layer.contents = nil
            }
        }
    }

    /// 取消指定 URL 的视频播放
    static func cancel(_ url: URL) {
        lock.withLock {
            shared.taskQueue.cancelTask(for: url)
        }
    }

    /// 取消指定视图的视频播放
    static func cancelForView(_ view: UIView) {
        lock.withLock {
            guard let url = view.cl.videoURL else { return }
            cancelForViewInternal(view, oldURL: url)
        }
    }

    /// 取消所有视频播放
    static func cancelAll() {
        lock.withLock {
            shared.taskQueue.cancelAllTasks()
        }
    }

    /// 暂停队列
    static func suspend() {
        lock.withLock {
            shared.taskQueue.suspend()
        }
    }

    /// 恢复队列
    static func resume() {
        lock.withLock {
            shared.taskQueue.resume()
        }
    }

    /// 销毁播放器
    static func destroy() {
        lock.withLock {
            shared.taskQueue.cancelAllTasks()
            manager = nil
        }
    }

    /// 清空缓存
    static func clearCache(completion: (() -> Void)? = nil) {
        CLVideoFrameCache.shared.clearAll(completion: completion)
    }

    /// 获取缓存大小
    static func getCacheSize(completion: @escaping (Int, Int) -> Void) {
        CLVideoFrameCache.shared.getCacheSize(completion: completion)
    }

    /// 设置最大并发数
    static func setMaxConcurrentOperationCount(_ count: Int) {
        lock.withLock {
            shared.taskQueue.maxConcurrentOperationCount = max(1, count)
        }
    }
}

// MARK: - 私有方法

extension CLVideoPlayer {
    private static func cancelForViewInternal(_ view: UIView, oldURL: URL) {
        if let task = shared.taskQueue.task(for: oldURL) {
            task.removeBindView(view)
        }
        view.cl.videoURL = nil
        view.layer.contents = nil
    }
}
