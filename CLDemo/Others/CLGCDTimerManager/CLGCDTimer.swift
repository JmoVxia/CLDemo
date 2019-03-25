//
//  CLGCDTimer.swift
//  CLDemo
//
//  Created by AUG on 2019/3/25.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit

class CLGCDTimer: NSObject {
    
    typealias actionBlock = ((NSInteger) -> Void)
    
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
    func responseOnceTimer() {
        actionTimes += 1
        isRuning = true
        action?(actionTimes)
        isRuning = false
    }
    deinit {
        cancelTimer()
    }
}

extension CLGCDTimer {
    ///开始定时器
    func startTimer() {
        timer.schedule(deadline: .now() + delaySecs, repeating: interval, leeway: DispatchTimeInterval.never)
        timer.setEventHandler { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.actionTimes += 1
            strongSelf.action?(strongSelf.actionTimes)
            if !strongSelf.repeats {
                strongSelf.cancelTimer()
            }
        }
        resumeTimer()
    }
    ///暂停
    func suspendTimer() {
        if isRuning {
            timer.suspend()
            isRuning = false
        }
    }
    ///恢复定时器
    func resumeTimer() {
        if !isRuning {
            timer.resume()
            isRuning = true;
        }
    }
    ///取消定时器
    func cancelTimer() {
        if !isRuning {
            resumeTimer()
        }
        timer.cancel()
    }
}
