//
//  CLGifPlayer.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/31.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLGifPlayer: NSObject {
    private static var manager: CLGifPlayer?
    private class var shared: CLGifPlayer {
        get {
            guard let shareManager = manager else {
                manager = CLGifPlayer()
                return manager!
            }
            return shareManager
        }
    }
    private var operationDictionary = [String : CLGifOperation]()
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
        CLLog("CLGifPlayer deinit")
    }
}
extension CLGifPlayer {
    static func startPlay(_ path: String, imageCallback: @escaping ((CGImage, String) -> ())) {
        cancel(path)
        let gifOperation = CLGifOperation(path: path, imageCallback: imageCallback)
        gifOperation.completionBlock = {
            removeValue(path)
            startPlay(path, imageCallback: imageCallback)
        }
        setOperation(gifOperation, for: path)
        shared.operationQueue.addOperation(gifOperation)
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
private extension CLGifPlayer {
    static func operation(_ value: String) -> CLGifOperation? {
        shared.operationSemap.wait()
        let operation = shared.operationDictionary[value]
        shared.operationSemap.signal()
        return operation
    }
    static func setOperation(_ value: CLGifOperation, for key: String) {
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
