//
//  CLGifPlayer.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/31.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLGifPlayer: NSObject {
    private let operationMap = CLMapTable<String, CLGifOperation>()

    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 10
        return queue
    }()

    private static var manager: CLGifPlayer?

    private static var shared: CLGifPlayer {
        guard let shareManager = manager else {
            manager = CLGifPlayer()
            return manager!
        }
        return shareManager
    }

    override private init() {}

    deinit {
        CLLog("CLGifPlayer deinit")
    }
}

extension CLGifPlayer {
    static func loadGif(with path: String, imageHandler: @escaping ((CGImage, String) -> Void)) -> String {
        if let operation = shared.operationMap.object(forKey: path) {
            print("\(String(describing: path.lastPathComponent))   =====   loadGif 存在   =====")
            operation.appendHandler(imageHandler)
        } else {
            let operation = CLGifOperation(path: path)
            operation.appendHandler(imageHandler)
            shared.operationMap.setObject(operation, forKey: path)
            shared.operationQueue.addOperation(operation)
            print("\(String(describing: path.lastPathComponent))   =====   loadGif 新建   =====")
        }
        return path
    }

    static func cancel(_ path: String?) {
        guard let path,
              let operation = shared.operationMap.object(forKey: path)
        else {
            print("\(String(describing: path?.lastPathComponent))   =====   cancel operation 不存在   =====")
            return
        }
        print("\(String(describing: path.lastPathComponent))   =====   CLGifPlayer cancel =====")
        operation.removeFristHandler()
        guard operation.contentHandlers.isEmpty else { return }
        operation.cancel()
        shared.operationMap.removeObject(forKey: path)
    }

    static func cacanAll() {
        shared.operationQueue.cancelAllOperations()
    }

    /// 销毁
    static func destroy() {
        cacanAll()
        manager = nil
    }
}
