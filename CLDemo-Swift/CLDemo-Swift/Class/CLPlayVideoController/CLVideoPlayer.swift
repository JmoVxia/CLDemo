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
        static var videoPath: UInt8 = 0
        static var debounceIntervalKey: UInt8 = 1
    }

    var path: String? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.videoPath) as? String }
        set { objc_setAssociatedObject(self, &AssociatedKeys.videoPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

class CLVideoPlayer: NSObject {
    private static var manager: CLVideoPlayer?
    private static let lock = NSLock()

    private var operations = [String: CLVideoOperation]()

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

    override private init() {}

    deinit {
        CLLog("CLVideoPlayer deinit")
    }
}

extension CLVideoPlayer {
    static func play(_ path: String, bindTo view: UIView) {
        withLock {
            guard shared.operations[path] == nil else { return }

            cancelOperation(view.path ?? "")
            view.path = path
            let videoOperation = CLVideoOperation(path: path, bindTo: view)
            videoOperation.completionBlock = { [weak manager] in
                guard let manager else { return }
                withLock {
                    manager.operations.removeValue(forKey: path)
                }
            }
            shared.operations[path] = videoOperation
            shared.operationQueue.addOperation(videoOperation)
        }
    }

    static func cancel(_ path: String) {
        withLock {
            cancelOperation(path)
        }
    }

    static func cancelAll() {
        withLock {
            cancelAllOperations()
        }
    }

    static func destroy() {
        withLock {
            cancelAllOperations()
            manager = nil
        }
    }
}

extension CLVideoPlayer {
    private static func cancelOperation(_ path: String) {
        guard let operation = shared.operations[path], !operation.isCancelled else { return }
        operation.bindView = nil
        operation.completionBlock = nil
        operation.cancel()
        shared.operations.removeValue(forKey: path)
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
