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
            shared.operationDictionary.removeValue(forKey: path)
            startPlay(path, imageCallback: imageCallback)
        }
        shared.operationDictionary[path] = videoOperation
        shared.operationQueue.addOperation(videoOperation)
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
        shared.operationDictionary.removeValue(forKey: path)
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
