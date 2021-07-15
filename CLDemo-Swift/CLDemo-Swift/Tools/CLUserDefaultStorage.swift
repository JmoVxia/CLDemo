//
//  CLUserDefaultStorage.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/15.
//

import UIKit

@propertyWrapper
public struct CLUserDefaultStorage<T: Codable> {
    var value: T?
    let keyName: String

    init(keyName: String) {
        value = UserDefaults.standard.value(forKey: keyName) as? T
        self.keyName = keyName
    }

    public var wrappedValue: T? {
        get { value }
        set {
            value = newValue
            if let value = newValue {
                UserDefaults.standard.setValue(value, forKey: keyName)
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.removeObject(forKey: keyName)
            }
        }
    }
}
