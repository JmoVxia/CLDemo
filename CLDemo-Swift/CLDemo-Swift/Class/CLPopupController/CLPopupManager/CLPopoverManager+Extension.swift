//
//  swift
//  FUSHENG
//
//  Created by JmoVxia on 2019/12/24.
//  Copyright © 2019 FuSheng. All rights reserved.
//

import UIKit
import DateToolsSwift

extension CLPopoverManager {
    /// 显示翻牌弹窗
    @discardableResult static func showFlop(configCallback: ((CLPopoverConfig) -> ())? = nil) -> String {
        return mainSync {
            let controller = CLPopupFlopController()
            configCallback?(controller.config)
            controller.show()
            return controller.key
        }
    }
    /// 显示可拖拽弹窗
    static func showDrag(configCallback: ((CLPopoverConfig) -> ())? = nil) {
        mainSync {
            let controller = CLPopupMomentumController()
            configCallback?(controller.config)
            controller.show()
        }
    }
    ///显示提示弹窗
    static func showTips(configCallback: ((CLPopoverConfig) -> ())? = nil, text: String, dismissInterval: TimeInterval = 1.0, dissmissCallBack: (() -> ())? = nil) {
        mainSync {
            let controller = CLPopupTipsController()
            configCallback?(controller.config)
            controller.text = text
            controller.dismissInterval = dismissInterval
            controller.dissmissCallBack = dissmissCallBack
            controller.show()
        }
    }
    ///显示一个消息弹窗
    static func showOneAlert(configCallback: ((CLPopoverConfig) -> ())? = nil, title: String? = nil, message: String? = nil, sure: String = "确定", sureCallBack: (() -> ())? = nil) {
        mainSync {
            let controller = CLPopupMessageController()
            configCallback?(controller.config)
            controller.type = .one
            controller.titleLabel.text = title
            controller.messageLabel.text = message
            controller.sureButton.setTitle(sure, for: .normal)
            controller.sureButton.setTitle(sure, for: .selected)
            controller.sureButton.setTitle(sure, for: .highlighted)
            controller.sureCallBack = sureCallBack
            controller.show()
        }
    }
    ///显示两个消息弹窗
    static func showTwoAlert(configCallback: ((CLPopoverConfig) -> ())? = nil, title: String? = nil, message: String? = nil, left: String = "取消", right: String = "确定", leftCallBack: (() -> ())? = nil, rightCallBack: (() -> ())? = nil) {
        mainSync {
            let controller = CLPopupMessageController()
            configCallback?(controller.config)
            controller.type = .two
            controller.titleLabel.text = title
            controller.messageLabel.text = message
            controller.leftButton.setTitle(left, for: .normal)
            controller.leftButton.setTitle(left, for: .selected)
            controller.leftButton.setTitle(left, for: .highlighted)
            controller.rightButton.setTitle(right, for: .normal)
            controller.rightButton.setTitle(right, for: .selected)
            controller.rightButton.setTitle(right, for: .highlighted)
            controller.leftCallBack = leftCallBack
            controller.rightCallBack = rightCallBack
            controller.show()
        }
    }
    ///显示成功
    static func showSuccess(configCallback: ((CLPopoverConfig) -> ())? = nil, strokeColor: UIColor = UIColor.red, text: String? = nil, dismissDuration: CGFloat = 1.0, dismissCallback: (() -> ())? = nil) {
        mainSync {
            let controller = CLPopupHudController()
            configCallback?(controller.config)
            controller.animationType = .success
            controller.strokeColor = strokeColor
            controller.text = text
            controller.dismissDuration = dismissDuration
            controller.dismissCallback = dismissCallback
            controller.show()
        }
    }
    ///显示错误
    static func showError(configCallback: ((CLPopoverConfig) -> ())? = nil, strokeColor: UIColor = .red, text: String? = nil, dismissDuration: CGFloat = 1.0, dismissCallback: (() -> ())? = nil) {
        mainSync {
            let controller = CLPopupHudController()
            configCallback?(controller.config)
            controller.animationType = .error
            controller.strokeColor = strokeColor
            controller.text = text
            controller.dismissDuration = dismissDuration
            controller.dismissCallback = dismissCallback
            controller.show()
        }
    }
    ///显示加载动画
    static func showHudLoading(configCallback: ((CLPopoverConfig) -> ())? = nil, strokeColor: UIColor = .red, text: String? = nil) {
        mainSync {
            let controller = CLPopupHudController()
            configCallback?(controller.config)
            controller.animationType = .loading
            controller.strokeColor = strokeColor
            controller.text = text
            controller.animationSize = CGSize(width: 80, height: 80)
            controller.show()
        }
    }
    ///显示年月日选择器
    static func showYearMonthDayDataPicker(configCallback: ((CLPopoverConfig) -> ())? = nil, minDate: Date = Date().subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 10)), maxDate: Date = Date(), yearMonthDayCallback: ((Int, Int, Int) -> ())? = nil) {
        mainSync {
            let controller = CLPopupDataPickerController()
            controller.minDate = minDate
            controller.maxDate = maxDate
            configCallback?(controller.config)
            controller.type = .yearMonthDay
            controller.yearMonthDayCallback = yearMonthDayCallback
            controller.show()
        }
    }
    ///显示时分选择器
    static func showHourMinuteDataPicker(configCallback: ((CLPopoverConfig) -> ())? = nil, hourMinuteCallback: ((Int, Int) -> ())? = nil) {
        mainSync {
            let controller = CLPopupDataPickerController()
            configCallback?(controller.config)
            controller.type = .hourMinute
            controller.hourMinuteCallback = hourMinuteCallback
            controller.show()
        }
    }
    ///显示年月日时分选择器
    static func showYearMonthDayHourMinuteDataPicker(configCallback: ((CLPopoverConfig) -> ())? = nil, yearMonthDayHourMinuteCallback: ((Int, Int, Int, Int, Int) -> ())? = nil) {
        mainSync {
            let controller = CLPopupDataPickerController()
            configCallback?(controller.config)
            controller.type = .yearMonthDayHourMinute
            controller.yearMonthDayHourMinuteCallback = yearMonthDayHourMinuteCallback
            controller.show()
        }
    }
    ///显示时长选择器
    static func showDurationDataPicker(configCallback: ((CLPopoverConfig) -> ())? = nil, durationCallback: ((String, String) -> ())? = nil) {
        mainSync {
            let controller = CLPopupDataPickerController()
            configCallback?(controller.config)
            controller.type = .duration
            controller.durationCallback = durationCallback
            controller.show()
        }
    }
    ///显示一个选择器
    static func showOnePicker(configCallback: ((CLPopoverConfig) -> ())? = nil, dataSource: [String], unit: String? = nil, space: CGFloat = -10, selectedCallback: ((String) -> ())? = nil) {
        mainSync {
            let controller = CLPopupDataPickerController()
            configCallback?(controller.config)
            controller.type = .one
            controller.unit = unit
            controller.space = space
            controller.dataSource = dataSource
            controller.selectedCallback = selectedCallback
            controller.show()
        }
    }
    ///显示BMI输入弹窗
    static func showBMIInput(configCallback: ((CLPopoverConfig) -> ())? = nil, bmiCallback: ((CGFloat) -> ())? = nil) {
        mainSync {
            let controller = CLPopupBMIInputController()
            configCallback?(controller.config)
            controller.bmiCallback = bmiCallback
            controller.show()
        }
    }
    ///显示一个输入框弹窗
    static func showOneInput(configCallback: ((CLPopoverConfig) -> ())? = nil, type: CLPopupOneInputType, sureCallback: ((String?) -> ())? = nil) {
        mainSync {
            let controller = CLPopupOneInputController()
            configCallback?(controller.config)
            controller.type = type
            controller.sureCallback = sureCallback
            controller.show()
        }
    }
    ///显示两个输入框弹窗
    static func showTwoInput(configCallback: ((CLPopoverConfig) -> ())? = nil, type: CLPopupTwoInputType, sureCallback: ((String?, String?) -> ())? = nil) {
        mainSync {
            let controller = CLPopupTwoInputController()
            configCallback?(controller.config)
            controller.type = type
            controller.sureCallback = sureCallback
            controller.show()
        }
    }
    ///显示食物选择器
    static func showFoodPicker(configCallback: ((CLPopoverConfig) -> ())? = nil, selectedCallback: ((String, String, String, String)->())?) {
        mainSync {
            let controller = CLPopupFoodPickerController()
            configCallback?(controller.config)
            controller.selectedCallback = selectedCallback
            controller.show()
        }
    }
    ///显示加载动画
    @discardableResult static func showLoading(configCallback: ((CLPopoverConfig) -> ())? = nil) -> String {
        return mainSync {
            let controller = CLPopupLoadingController()
            configCallback?(controller.config)
            controller.show()
            return controller.key
        }
    }
}
