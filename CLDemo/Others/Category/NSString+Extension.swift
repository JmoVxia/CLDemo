//
//  NSString+Extension.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

extension String {
    ///验证邮箱
    func isValidEmailStricterFilter(stricterFilter: Bool = true) -> Bool {
        let stricterFilterString = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let laxString = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let regex = stricterFilter ? stricterFilterString : laxString
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    ///验证指定位数纯数字
    func isValidNumberEqual(to count: Int) -> Bool {
        let regex = "^[0-9]{\(count)}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    ///验证全部是空格
    func isValidAllEmpty() -> Bool {
        let regex = "^\\s*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    ///验证是否纯数字
    func isValidPureNumbers() -> Bool {
        let regex = "^[0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    ///验证是否小于等于指定位数的纯数字
    func isValidNumbersLessThanOrEqual(to count: Int) -> Bool {
        let regex = "^[0-9]{0,\(count)}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    ///验证小数点后位数
    func isValidDecimalPointCount(_ count: Int) -> Bool {
        let regex = "^[0-9]+(\\.[0-9]{0,\(count)})?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    ///是否是合法账号(只含有数字、字母、下划线、@、. 位数1到30位)
    func isValidAccount() -> Bool {
        let regex = "^[a-zA-Z0-9_.@]{1,30}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    ///是否是有效中文姓名
    func isValidChineseName() -> Bool {
        let regex = "^[\u{4e00}-\u{9fa5}]+(·[\u{4e00}-\u{9fa5}]+)*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    ///是否是有效英文姓名
    func isValidEnglishName() -> Bool {
        let regex = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}
