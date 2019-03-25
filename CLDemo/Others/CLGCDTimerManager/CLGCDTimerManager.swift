//
//  CLGCDTimerManager.swift
//  CLDemo
//
//  Created by AUG on 2019/3/25.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit

typealias actionBlock = ((NSInteger) -> Void)


class CLGCDTimer: NSObject {
    
    ///执行时间
    private var interval: TimeInterval!
    ///延迟时间
    private var delaySecs: TimeInterval!
    ///队列
    private var serialQueue: DispatchQueue!
    ///是否重复
    private var repeats: Bool = true
    ///响应
    private var action: actionBlock?
    ///定时器
    private var timer: DispatchSourceTimer!
    ///是否正在运行
    private var isRuning: Bool = false
    ///响应次数
    private (set) var actionTimes: NSInteger = 0
    
    init(interval: TimeInterval, delaySecs: TimeInterval, queue: DispatchQueue = DispatchQueue.main, repeats: Bool = true, action:  actionBlock?) {
        super.init()
        self.interval = interval
        self.delaySecs = delaySecs
        self.serialQueue = DispatchQueue.init(label: String(format: "CLGCDTimer.%p", self), target: queue)
        self.action = action
        self.timer = DispatchSource.makeTimerSource(queue: self.serialQueue)
    }
    ///替换旧响应
    func replaceOldAction(action: actionBlock?) -> Void {
        guard let action = action else {
            return
        }
        self.action = action
    }
    ///执行一次定时器响应
    func responseOnce() {
        actionTimes += 1
        isRuning = true
        action?(actionTimes)
        isRuning = false
    }
    deinit {
        cancel()
    }
}

extension CLGCDTimer {
    ///开始定时器
    func start() {
        timer.schedule(deadline: .now() + delaySecs, repeating: interval, leeway: DispatchTimeInterval.never)
        timer.setEventHandler { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.actionTimes += 1
            strongSelf.action?(strongSelf.actionTimes)
            if !strongSelf.repeats {
                strongSelf.cancel()
            }
        }
        resume()
    }
    ///暂停
    func suspend() {
        if isRuning {
            timer.suspend()
            isRuning = false
        }
    }
    ///恢复定时器
    func resume() {
        if !isRuning {
            timer.resume()
            isRuning = true;
        }
    }
    ///取消定时器
    func cancel() {
        if !isRuning {
            resume()
        }
        timer.cancel()
    }
}

class CLGCDTimerManager: NSObject {
    static let sharedManager: CLGCDTimerManager = CLGCDTimerManager()
    private var timerObjectCache: Dictionary<String, CLGCDTimer> = Dictionary()
    private let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    private override init() {
       semaphore.signal()
    }
    ///创建定时器
    func scheduledTimer(name: String, interval: TimeInterval, delaySecs: TimeInterval, queue: DispatchQueue = DispatchQueue.main, repeats: Bool = true, action:  actionBlock?) {
        var GCDTimer: CLGCDTimer? = timer(name)
        if (GCDTimer != nil) {
            return
        }
        GCDTimer = CLGCDTimer(interval: interval, delaySecs: delaySecs, queue: queue, repeats: repeats, action: action)
        setTimer(GCDTimer!, name)
    }
}
extension CLGCDTimerManager {
    ///开始定时器
    func start(_ name: String) {
        let GCDTimer: CLGCDTimer? = timer(name)
        GCDTimer?.start()
    }
    ///执行一次定时器
    func responseOnce(_ name: String) {
        let GCDTimer: CLGCDTimer? = timer(name)
        GCDTimer?.responseOnce()
    }
    ///取消定时器
    func cancel(_ name: String) {
        let GCDTimer: CLGCDTimer? = timer(name)
        guard let timer = GCDTimer else {
            return
        }
        timer.cancel()
        removeTimer(name)
    }
    ///暂停定时器
    func suspend(_ name: String) {
        let GCDTimer: CLGCDTimer? = timer(name)
        GCDTimer?.suspend()
    }
    ///恢复定时器
    func resume(_ name: String) {
        let GCDTimer: CLGCDTimer? = timer(name)
        GCDTimer?.resume()
    }
}
extension CLGCDTimerManager {
    private func timer(_ name: String) -> CLGCDTimer? {
        semaphore.wait()
        let GCDTimer = timerObjectCache[name]
        semaphore.signal()
        return GCDTimer
    }
    private func setTimer(_ timer: CLGCDTimer, _ name: String) {
        semaphore.wait()
        timerObjectCache.updateValue(timer, forKey: name)
        semaphore.signal()
    }
    private func removeTimer(_ name: String) {
        semaphore.wait()
        timerObjectCache.removeValue(forKey: name)
        semaphore.signal()
    }
}
