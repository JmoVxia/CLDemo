//
//  CLCalendarConfig.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//
import UIKit
import DateToolsSwift

struct CLCalendarConfig {
    enum CLSelectType {
        case single
        case area
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
    var beginDate = Date() - 5.months
    var endDate = Date() + 5.months
    var position = Date()
    var selectType = CLSelectType.area
    var limitBegin: Date?
    var limitEnd: Date?
    var isShowLunarCalendar = true
    var insetsLayoutMarginsFromSafeArea = true
    var headerHight = 50.0
}
