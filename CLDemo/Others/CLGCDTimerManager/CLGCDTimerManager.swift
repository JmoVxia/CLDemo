//
//  CLGCDTimerManager.swift
//  CLDemo
//
//  Created by AUG on 2019/3/24.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit


class CLGCDTimer: NSObject {
    
    typealias actionBlock = ((NSInteger) -> Void)

    ///定时器名字
    private var name: String?
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
    
    init(name: String? = nil, interval: TimeInterval, delaySecs: TimeInterval, queue: DispatchQueue = DispatchQueue.main, repeats: Bool = true, action: @escaping actionBlock) {
        super.init()
        self.name = name
        self.interval = interval
        self.delaySecs = delaySecs
        self.serialQueue = DispatchQueue.init(label: String(format: "CLGCDTimer.%p", self), target: queue)
        self.action = action
        self.timer = DispatchSource.makeTimerSource(queue: self.serialQueue)
    }
    ///替换旧响应
    func replaceOldAction(action: actionBlock?) -> Void {
        self.action = action
    }
    ///执行一次定时器响应
    func responseOnceTimer() {
        actionTimes += 1
        isRuning = true
        action?(actionTimes)
        isRuning = false
    }
}
extension CLGCDTimer {
    ///开始定时器
    func startTimer() {
        timer.schedule(deadline: .now() + delaySecs, repeating: interval, leeway: DispatchTimeInterval.never)
        timer.setEventHandler {
            self.actionTimes += 1
            self.action?(self.actionTimes)
            if !self.repeats {
                self.cancelTimer()
            }
        }
        resumeTimer()
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
    ///暂停
    func suspendTimer() {
        if isRuning {
            timer.suspend()
            isRuning = false
        }
    }
}
class CLGCDTimerManager: NSObject {
    static let sharedManager:CLGCDTimerManager = CLGCDTimerManager()
    private override init() {

    }
}
