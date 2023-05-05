//
//  CLSafeArrayDictionary.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2024/1/4.
//

import Foundation

struct CLSafeArrayDictionary<Key: Hashable, Value> {
    private var dictionary: [Key: [Value]] = [:]
    private let semaphore = DispatchSemaphore(value: 1)

    subscript(key: Key) -> [Value]? {
        get {
            semaphore.wait()
            defer {
                semaphore.signal()
            }
            return dictionary[key]
        }
        set(newValue) {
            semaphore.wait()
            defer {
                semaphore.signal()
            }
            if let newValue {
                if var existingArray = dictionary[key] {
                    existingArray.append(contentsOf: newValue)
                    dictionary[key] = existingArray
                } else {
                    dictionary[key] = newValue
                }
            } else {
                dictionary.removeValue(forKey: key)
            }
        }
    }

    mutating func remove(key: Key) {
        semaphore.wait()
        defer {
            semaphore.signal()
        }
        dictionary.removeValue(forKey: key)
    }
}
