//
//  CLCalendarDelegate.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//

import Foundation

protocol CLCalendarDelegate: AnyObject {
    func didSelectDate(date: Date, in view: CLCalendarView)
}

extension CLCalendarDelegate {
    func didSelectDate(date: Date, in view: CLCalendarView) {}
}
