//
//  CLVideoTaskQueue.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import Foundation

// MARK: - CLVideoTaskQueue

class CLVideoTaskQueue {
    /// 最大并发任务数
    var maxConcurrentOperationCount = 10

    private(set) var isSuspended = false

    var taskCount: Int {
        lock.withLock { tasks.count }
    }

    private var tasks: [CLVideoTask] = []
    private let lock = NSRecursiveLock()
}

// MARK: - 任务管理

extension CLVideoTaskQueue {
    /// 添加任务
    func addTask(_ task: CLVideoTask) {
        lock.withLock {
            task.stateDidChange = { [weak self] in
                self?.handleTaskStateChange()
            }
            task.setWaitingState()
            tasks.append(task)
        }
        scheduleNextTaskIfNeeded()
    }

    /// 根据 URL 查找任务
    func task(for url: URL) -> CLVideoTask? {
        lock.withLock {
            tasks.first { $0.url == url }
        }
    }

    /// 取消指定 URL 的任务
    func cancelTask(for url: URL) {
        let task = lock.withLock {
            tasks.first { $0.url == url }
        }
        task?.cancel()
    }

    /// 取消所有任务
    func cancelAllTasks() {
        let allTasks = lock.withLock { tasks }
        allTasks.forEach { $0.cancel() }
    }

    /// 暂停队列
    func suspend() {
        lock.withLock {
            isSuspended = true
            tasks.filter { $0.state == .executing }.forEach { $0.suspend() }
        }
    }

    /// 恢复队列
    func resume() {
        lock.withLock {
            isSuspended = false
            tasks.filter { $0.state == .suspended }.forEach { $0.resume() }
        }
        scheduleNextTaskIfNeeded()
    }
}

// MARK: - 调度逻辑

extension CLVideoTaskQueue {
    private func scheduleNextTaskIfNeeded() {
        let taskToStart: CLVideoTask? = lock.withLock {
            guard !isSuspended else { return nil }

            if maxConcurrentOperationCount > 0 {
                let executingCount = tasks.filter { $0.state == .executing }.count
                guard executingCount < maxConcurrentOperationCount else { return nil }
                return tasks.first { $0.state == .waiting }
            } else {
                let waitingTasks = tasks.filter { $0.state == .waiting }
                waitingTasks.forEach { $0.start() }
                return nil
            }
        }
        taskToStart?.start()
    }

    private func removeFinishedTasks() {
        lock.withLock {
            tasks.removeAll { $0.state.isFinal }
        }
    }

    private func handleTaskStateChange() {
        removeFinishedTasks()
        scheduleNextTaskIfNeeded()
    }
}
