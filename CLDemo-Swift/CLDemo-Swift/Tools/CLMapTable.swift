//
//  CLMapTable.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2024/8/23.
//

import Foundation

struct CLMapTable<Key: Hashable, Value: AnyObject> {
    private let mapTable = NSMapTable<WrappedKey<Key>, Value>.strongToWeakObjects()
    private let queue = DispatchQueue(label: "com.CKDMapTable.queue")

    /// 获取所有键
    var keys: [Key] {
        queue.sync {
            mapTable.keyEnumerator().allObjects.compactMap { ($0 as? WrappedKey<Key>)?.value }
        }
    }

    /// 获取所有值
    var values: [Value] {
        queue.sync {
            mapTable.objectEnumerator()?.allObjects.compactMap { $0 as? Value } ?? []
        }
    }

    /// 获取指定键的对象
    func object(forKey aKey: Key) -> Value? {
        queue.sync {
            mapTable.object(forKey: WrappedKey(aKey))
        }
    }

    /// 设置指定键的对象
    func setObject(_ anObject: Value, forKey aKey: Key) {
        queue.sync {
            mapTable.setObject(anObject, forKey: WrappedKey(aKey))
        }
    }

    /// 移除指定键的对象
    func removeObject(forKey aKey: Key) {
        queue.sync {
            mapTable.removeObject(forKey: WrappedKey(aKey))
        }
    }

    private class WrappedKey<T: Hashable>: NSObject {
        let value: T

        init(_ value: T) {
            self.value = value
            super.init()
        }

        override var hash: Int {
            value.hashValue
        }

        override func isEqual(_ object: Any?) -> Bool {
            guard let other = object as? WrappedKey<T> else { return false }
            return value == other.value
        }
    }
}
