//
//  CLCalendarConfig.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//
import UIKit

struct CLCalendarConfig {
    enum CLCalendarType {
        case past
        case today
        case future
    }

    enum CLSelectType {
        case single
        case area
    }

    struct CLTouchType: OptionSet {
        static let past = CLTouchType(rawValue: 1)
        static let today = CLTouchType(rawValue: 1 << 1)
        static let future = CLTouchType(rawValue: 1 << 2)
        let rawValue: Int64
        init(rawValue: Int64) {
            self.rawValue = rawValue
        }
    }

    struct CLColor {
        var background = "#ffffff".uiColor
        var topToolBackground = "#F4F4F4".uiColor
        var topToolText = "#444444".uiColor
        var topToolTextWeekend = "#3CCA79".uiColor
        var sectionBackgroundText = "f2f2f2".uiColor
        var selectStartBackground = "#4bce817f".uiColor
        var selectBackground = "#afe9c77f".uiColor
        var selectEndBackground = "#4bce817f".uiColor
        var todayText = "#32cd32".uiColor
        var titleText = "#555555".uiColor
        var subtitleText = "#555555".uiColor
        var selectTodayText = "#32cd32".uiColor
        var selectTitleText = "#ffffff".uiColor
        var selectSubtitleText = "#ffffff".uiColor
        var failureTitleText = "#a9a9a9".uiColor
        var failureSubtitleText = "#a9a9a9".uiColor
        var failureBackground = "#dcdcdc32".uiColor
    }

    var color = CLColor()
    var selectBegin: Date?
    var selectEnd: Date?
    var limitMonth = 12
    var type = CLCalendarType.today
    var selectType = CLSelectType.area
    var touchType: CLTouchType = [.today, .past]
    var isShowLunarCalendar = true
    var insetsLayoutMarginsFromSafeArea = true
    var headerHight = 50.0
}
