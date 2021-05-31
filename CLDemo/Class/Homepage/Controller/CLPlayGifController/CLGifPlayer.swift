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
    private override init() {
        
    }
    private lazy var operationSemap: DispatchSemaphore = {
        let semap = DispatchSemaphore(value: 0)
        semap.signal()
        return semap
    }()
    deinit {
        CLLog("CLGifPlayer deinit")
    }
}
extension CLGifPlayer {
    static func startPlay(_ path: String, imageCallback: @escaping ((CGImage, String) -> ())) {
        cancel(path)
        let gifOperation = CLGifOperation(path: path, imageCallback: imageCallback)
        gifOperation.completionBlock = {
            shared.operationSemap.wait()
            shared.operationDictionary.removeValue(forKey: path)
            shared.operationSemap.signal()
            startPlay(path, imageCallback: imageCallback)
        }
        shared.operationDictionary[path] = gifOperation
        shared.operationQueue.addOperation(gifOperation)
    }
    static func cancel(_ path: String) {
        guard let operation = shared.operationDictionary[path],
              !operation.isCancelled
        else {
            return
        }
        operation.imageCallback = nil
        operation.completionBlock = nil
        operation.cancel()
        shared.operationSemap.wait()
        shared.operationDictionary.removeValue(forKey: path)
        shared.operationSemap.signal()
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
