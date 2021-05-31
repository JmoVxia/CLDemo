//
//  CLGifOperation.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/31.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLGifOperation: Operation {
    var imageCallback: ((CGImage, String) -> ())?
    private var path: String!
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
        return taskFinished
    }
    override var isExecuting: Bool {
        return taskExecuting
    }
    override var isAsynchronous: Bool {
        return true
    }
    init(path: String, imageCallback: @escaping ((CGImage, String) -> ())) {
        self.path = path
        self.imageCallback = imageCallback
        super.init()
    }
    deinit {
//        CLLog("CLGifOperation deinit")
    }
}
extension CLGifOperation {
    override func start() {
        autoreleasepool {
            if isCancelled {
                taskFinished = true
                taskExecuting = false
            }else {
                taskFinished = false
                taskExecuting = true
                startTask {
                    taskFinished = true
                    taskExecuting = false
                }
            }
        }
    }
    override func cancel() {
        if (isExecuting) {
            taskFinished = true
            taskExecuting = false
        }
        super.cancel()
    }
}
extension CLGifOperation {
    private func startTask(_ complete: (() -> ())) {
        defer {
            complete()
        }
        guard let data = NSData(contentsOfFile: path),
              let imageSource = CGImageSourceCreateWithData(data, nil)
        else {
            return
        }
        let imageCount = CGImageSourceGetCount(imageSource)
        var i = 0
        while imageCount > i, !isCancelled {
            guard let image = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { break }
            let timePerFrame = getCGImageSourceGifFrameDelay(imageSource: imageSource, index: i)
            DispatchQueue.main.async {
                self.imageCallback?(image, self.path)
            }
            i += 1
            Thread.sleep(forTimeInterval: timePerFrame)
        }
    }
}
extension CLGifOperation {
    private func getCGImageSourceGifFrameDelay(imageSource: CGImageSource, index: Int) -> TimeInterval {
        var delay = 0.1
        guard let imgProperties: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil),
              let property = imgProperties[kCGImagePropertyGIFDictionary as String] as? NSDictionary
        else {
            return delay
        }
        if let unclampedDelayTime = property[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber {
            delay = unclampedDelayTime.doubleValue
        }
        if delay <= 0, let delayTime = property[kCGImagePropertyGIFDelayTime as String] as? NSNumber {
            delay = delayTime.doubleValue
        }
        if delay < 0.011 {
            delay = 0.1
        }
        return delay
    }
}
