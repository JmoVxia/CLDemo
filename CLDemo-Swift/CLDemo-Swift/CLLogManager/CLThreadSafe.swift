//
//  CLThreadSafe.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2025/7/30.
//

import Foundation

// MARK: - JmoVxia---线程安全属性包装

@propertyWrapper
class CLThreadSafe<Value> {
    private var value: Value
    private var lock = os_unfair_lock_s()

    init(wrappedValue: Value) {
        value = wrappedValue
    }

    var wrappedValue: Value {
        get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return value
        }
        set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            value = newValue
        }
    }
}
