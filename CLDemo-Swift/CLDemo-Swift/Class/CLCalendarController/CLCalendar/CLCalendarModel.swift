//
//  CLCalendarModel.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//

import UIKit

struct CLCalendarDayModel {
    enum CLCalendarDayType {
        case empty
        case past
        case today
        case future
    }

    var title: String?
    var date: Date?
    var subtitle: String?
    var type: CLCalendarDayType = .empty
}

struct CLCalendarMonthModel {
    var headerText = ""
    var month = ""
    var daysArray = [CLCalendarDayModel]()
}
