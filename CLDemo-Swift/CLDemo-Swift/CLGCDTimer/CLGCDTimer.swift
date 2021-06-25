//
//  CLGCDTimer.swift
//  CL
//
//  Created by JmoVxia on 2020/5/21.
//  Copyright © 2020 JmoVxia. All rights reserved.
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
    
    /// 创建定时器
    ///
    /// - Parameters:
    ///   - interval: 间隔时间
    ///   - delaySecs: 第一次执行延迟时间，默认为0
    ///   - queue: 定时器调用的队列，默认主队列
    ///   - repeats: 是否重复执行，默认true
    ///   - action: 响应
    init(interval: TimeInterval, delaySecs: TimeInterval = 0, queue: DispatchQueue = .main, repeats: Bool = true, action: actionBlock?) {
        super.init()
        self.interval = interval
        self.delaySecs = delaySecs
        self.repeats = repeats
        self.serialQueue = queue
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
        timer.schedule(deadline: .now() + delaySecs, repeating: interval)
        timer.setEventHandler { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.actionTimes += 1
            strongSelf.action?(strongSelf.actionTimes)
            if !strongSelf.repeats {
                strongSelf.cancel()
                strongSelf.action = nil
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
