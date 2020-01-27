//
//  NSString+Extension.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

extension NSString {
    ///是否全是空格
    func isValidAllEmpty() -> Bool {
        let regex = "^\\s*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}
