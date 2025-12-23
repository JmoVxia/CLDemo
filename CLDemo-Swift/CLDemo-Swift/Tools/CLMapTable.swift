//
//  CLMapTable.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2024/8/23.
//

import Foundation

enum CLMapTableKeyType {
    case strong
    case weak
}

enum CLMapTableValueType {
    case strong
    case weak
}

struct CLMapTable<Key: Hashable, Value> {
    private let mapTable: NSMapTable<WrappedKey<Key>, WrappedValue<Value>>
    private let queue = DispatchQueue(label: "com.CLMapTable.queue")

    init(keyType: CLMapTableKeyType = .strong, valueType: CLMapTableValueType = .weak) {
        switch (keyType, valueType) {
        case (.strong, .strong):
            mapTable = NSMapTable<WrappedKey<Key>, WrappedValue<Value>>.strongToStrongObjects()
        case (.strong, .weak):
            mapTable = NSMapTable<WrappedKey<Key>, WrappedValue<Value>>.strongToWeakObjects()
        case (.weak, .strong):
            mapTable = NSMapTable<WrappedKey<Key>, WrappedValue<Value>>.weakToStrongObjects()
        case (.weak, .weak):
            mapTable = NSMapTable<WrappedKey<Key>, WrappedValue<Value>>.weakToWeakObjects()
        }
    }

    /// 获取所有键
    var keys: [Key] {
        queue.sync {
            mapTable.keyEnumerator().allObjects.compactMap { ($0 as? WrappedKey<Key>)?.value }
        }
    }

    /// 获取所有值
    var values: [Value] {
        queue.sync {
            mapTable.objectEnumerator()?.allObjects.compactMap { ($0 as? WrappedValue<Value>)?.value } ?? []
        }
    }

    /// 获取指定键的对象
    func object(forKey aKey: Key) -> Value? {
        queue.sync {
            mapTable.object(forKey: WrappedKey(aKey))?.value
        }
    }

    /// 设置指定键的对象
    func setObject(_ anObject: Value, forKey aKey: Key) {
        queue.sync {
            mapTable.setObject(WrappedValue(anObject), forKey: WrappedKey(aKey))
        }
    }

    /// 按照指定键移除对象
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

    private class WrappedValue<T>: NSObject {
        let value: T

        init(_ value: T) {
            self.value = value
            super.init()
        }
    }
}
