//
//  CLGCDTimer.swift
//  CL
//
//  Created by JmoVxia on 2020/5/21.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLGCDTimer: NSObject {
    enum State {
        case suspended
        case resumed
    }

    /// 执行时间
    private(set) var interval: TimeInterval!
    /// 延迟时间
    private(set) var delaySecs: TimeInterval!
    /// 队列
    private(set) var serialQueue: DispatchQueue!
    /// 定时器
    private(set) var timer: DispatchSourceTimer!
    /// 是否正在运行
    private(set) var state: State = .suspended
    /// 响应次数
    private(set) var actionTimes = Int.zero
    /// 响应
    private(set) var eventHandler: ((Int) -> Void)?

    /// 创建定时器
    ///
    /// - Parameters:
    ///   - interval: 间隔时间
    ///   - delaySecs: 第一次执行延迟时间，默认为0
    ///   - queue: 定时器调用的队列，默认主队列
    ///   - repeats: 是否重复执行，默认true
    ///   - action: 响应
    init(interval: TimeInterval,
         delaySecs: TimeInterval = 0,
         queue: DispatchQueue = .main)
    {
        super.init()
        self.interval = interval
        self.delaySecs = delaySecs
        serialQueue = queue
        timer = DispatchSource.makeTimerSource(queue: serialQueue)
        timer.schedule(deadline: .now() + delaySecs, repeating: interval)
        timer.setEventHandler { [weak self] in
            guard let self else { return }
            actionTimes += 1
            eventHandler?(actionTimes)
        }
    }

    deinit {
        timer?.setEventHandler(handler: nil)
        timer?.cancel()
        eventHandler = nil
        resume()
    }
}

extension CLGCDTimer {
    /// 开始
    func start(_ handler: @escaping ((_ count: Int) -> Void)) {
        eventHandler = handler
        resume()
    }

    /// 暂停
    func suspend() {
        guard let timer else { return }
        guard state != .suspended else { return }
        state = .suspended
        timer.suspend()
    }

    /// 恢复定时器
    func resume() {
        guard state != .resumed else { return }
        guard let timer else { return }
        state = .resumed
        timer.resume()
    }
}
