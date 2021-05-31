//
//  CLVideoPlayer.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLVideoPlayer: NSObject {
    private static var manager: CLVideoPlayer?
    private class var shared: CLVideoPlayer {
        get {
            guard let shareManager = manager else {
                manager = CLVideoPlayer()
                return manager!
            }
            return shareManager
        }
    }
    private var operationDictionary = [String : CLVideoOperation]()
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10
        return queue
    }()
    private lazy var operationSemap: DispatchSemaphore = {
        let semap = DispatchSemaphore(value: 0)
        semap.signal()
        return semap
    }()
    private override init() {
        
    }
    deinit {
        CLLog("CLVideoPlayer deinit")
    }
}
extension CLVideoPlayer {
    static func startPlay(_ path: String, imageCallback: @escaping ((CGImage, String) -> ())) {
        cancel(path)
        let videoOperation = CLVideoOperation(path: path, imageCallback: imageCallback)
        videoOperation.completionBlock = {
            removeValue(path)
            startPlay(path, imageCallback: imageCallback)
        }
        setOperation(videoOperation, for: path)
        shared.operationQueue.addOperation(videoOperation)
    }
    static func cancel(_ path: String) {
        guard let operation = operation(path),
              !operation.isCancelled
        else {
            return
        }
        operation.imageCallback = nil
        operation.completionBlock = nil
        operation.cancel()
        removeValue(path)
    }
    static func cacanAll() {
        shared.operationDictionary.keys.forEach { key in
            cancel(key)
        }
    }
    ///销毁
    static func destroy() {
        cacanAll()
        manager = nil
    }
}
private extension CLVideoPlayer {
    static func operation(_ value: String) -> CLVideoOperation? {
        shared.operationSemap.wait()
        let operation = shared.operationDictionary[value]
        shared.operationSemap.signal()
        return operation
    }
    static func setOperation(_ value: CLVideoOperation, for key: String) {
        shared.operationSemap.wait()
        shared.operationDictionary[key] = value
        shared.operationSemap.signal()
    }
    static func removeValue(_ value: String) {
        shared.operationSemap.wait()
        shared.operationDictionary.removeValue(forKey: value)
        shared.operationSemap.signal()
    }
}
