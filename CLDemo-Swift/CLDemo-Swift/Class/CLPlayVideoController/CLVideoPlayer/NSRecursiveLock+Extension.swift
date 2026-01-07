//
//  NSRecursiveLock+Extension.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import Foundation

extension NSRecursiveLock {
    /// 在锁保护下执行闭包
    @discardableResult
    func withLock<T>(_ block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
