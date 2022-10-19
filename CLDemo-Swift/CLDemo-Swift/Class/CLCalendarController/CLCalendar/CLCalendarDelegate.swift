//
//  CLCalendarDelegate.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//

import Foundation

protocol CLCalendarDelegate: AnyObject {
    func didSelectArea(begin: Date, end: Date, in view: CLCalendarView)
    func didSelectSingle(date: Date, in view: CLCalendarView)
}

extension CLCalendarDelegate {
    func didSelectArea(begin: Date, end: Date, in view: CLCalendarView) {}
    func didSelectSingle(date: Date, in view: CLCalendarView) {}
}
