//
//  swift
//  FUSHENG
//
//  Created by JmoVxia on 2019/12/24.
//  Copyright © 2019 FuSheng. All rights reserved.
//

import UIKit
//MARK: - 弹窗父类控制器

@objcMembers class CLPopupManagerBaseController: UIViewController {
    ///状态栏颜色
    var statusBarStyle: UIStatusBarStyle = UIApplication.shared.statusBarStyle
    ///是否自动旋转
    var autorotate: Bool = false
    ///支持方向
    var interfaceOrientationMask: UIInterfaceOrientationMask = .portrait
    ///是否隐藏状态栏
    var statusBarHidden: Bool = false
}
extension CLPopupManagerBaseController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    override var shouldAutorotate: Bool {
        return autorotate
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientationMask
    }
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
}
//MARK: - 弹窗Window
@objcMembers class CLPopupManagerWindow: UIWindow {
    ///向下传递手势
    var isPassedDown: Bool = false
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == rootViewController?.view {
            return isPassedDown ? nil : view
        }
        return view
    }
}
//MARK: - 弹窗管理者
@objcMembers class CLPopupManager: NSObject {
    private static var manager: CLPopupManager?
    private class var share: CLPopupManager {
        get {
            guard let shareManager = manager else {
                manager = CLPopupManager()
                return manager!
            }
            return shareManager
        }
    }
    private var windowsArray = [CLPopupManagerWindow]()
    private override init() {
        super.init()
    }
    deinit {
        print("============== PopupViewManager deinit ==================")
    }
}
extension CLPopupManager {
    /// 显示弹窗
    /// - Parameters:
    ///   - controller: 弹窗控制器
    ///   - displacement: 顶掉前面弹窗
    private class func makeKeyAndVisible(with controller: UIViewController, displacement: Bool, passedDown: Bool) {
        if displacement {
            share.windowsArray.removeAll()
        }
        let popupManagerWindow = CLPopupManagerWindow(frame: UIScreen.main.bounds)
        popupManagerWindow.isPassedDown = passedDown
        popupManagerWindow.windowLevel = UIWindow.Level.statusBar
        popupManagerWindow.isUserInteractionEnabled = true
        popupManagerWindow.rootViewController = controller
        popupManagerWindow.makeKeyAndVisible()
        share.windowsArray.append(popupManagerWindow)
    }
    /// 销毁弹窗
    /// - Parameter all: 是否销毁所有弹窗
    private class func destroyAll(_ all: Bool = true) {
        if all {
            share.windowsArray.removeAll()
        }else {
            share.windowsArray.removeLast()
        }
        if share.windowsArray.count == 0 {
            manager = nil
        }
    }
}
extension CLPopupManager {
    /// 显示自定义弹窗
    /// - Parameters:
    ///   - controller: 自定义弹窗控制器
    ///   - displacement: 顶掉前面弹窗弹窗
    class func showCustom(with controller: UIViewController, displacement: Bool = false, passedDown: Bool = false) {
        DispatchQueue.main.async {
            makeKeyAndVisible(with: controller, displacement: displacement, passedDown: passedDown)
        }
    }
    /// 隐藏弹窗
    /// - Parameter all: 全部弹窗
    class func dismissAll(_ all: Bool = true) {
        DispatchQueue.main.async {
            destroyAll(all)
        }
    }
    /// 显示翻牌弹窗
    class func showFlop(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false) {
        let controller = CLPopupFlopController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示提示弹窗
    class func showTips(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, text: String, dismissInterval: TimeInterval = 1.0) {
        let controller = CLPopupTipsController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.text = text
        controller.dismissInterval = dismissInterval
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示一个消息弹窗
    class func showOneAlert(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, title: String? = nil, message: String? = nil, sure: String = "确定", sureCallBack: (() -> ())? = nil) {
        let controller = CLPopupMessageController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = .one
        controller.titleLabel.text = title
        controller.messageLabel.text = message
        controller.sureButton.setTitle(sure, for: .normal)
        controller.sureButton.setTitle(sure, for: .selected)
        controller.sureButton.setTitle(sure, for: .highlighted)
        controller.sureCallBack = sureCallBack
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示两个消息弹窗
    class func showTwoAlert(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, title: String? = nil, message: String? = nil, left: String = "取消", right: String = "确定", leftCallBack: (() -> ())? = nil, rightCallBack: (() -> ())? = nil) {
        let controller = CLPopupMessageController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
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
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示成功
    class func showSuccess(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, strokeColor: UIColor = UIColor.red, text: String? = nil, dismissDuration: CGFloat = 1.0, dismissCallback: (() -> ())? = nil) {
        let controller = CLPopupHudController()
        controller.animationType = .success
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.strokeColor = strokeColor
        controller.text = text
        controller.dismissDuration = dismissDuration
        controller.dismissCallback = dismissCallback
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示错误
    class func showError(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, strokeColor: UIColor = UIColor.red, text: String? = nil, dismissDuration: CGFloat = 1.0, dismissCallback: (() -> ())? = nil) {
        let controller = CLPopupHudController()
        controller.animationType = .error
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.strokeColor = strokeColor
        controller.text = text
        controller.dismissDuration = dismissDuration
        controller.dismissCallback = dismissCallback
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示加载
    class func showLoading(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, strokeColor: UIColor = UIColor.red, text: String? = nil) {
        let controller = CLPopupHudController()
        controller.animationType = .loading
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.strokeColor = strokeColor
        controller.text = text
        controller.animationSize = CGSize(width: 80, height: 80)
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示年月日选择器
    class func showYearMonthDayDataPicker(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = true, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, yearMonthDayCallback: ((Int, Int, Int) -> ())? = nil) {
        let controller = CLPopupDataPickerController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = .yearMonthDay
        controller.yearMonthDayCallback = yearMonthDayCallback
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示时分选择器
    class func showHourMinuteDataPicker(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = true, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, hourMinuteCallback: ((Int, Int) -> ())? = nil) {
        let controller = CLPopupDataPickerController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = .hourMinute
        controller.hourMinuteCallback = hourMinuteCallback
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示年月日时分选择器
    class func showYearMonthDayHourMinuteDataPicker(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = true, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, yearMonthDayHourMinuteCallback: ((Int, Int, Int, Int, Int) -> ())? = nil) {
        let controller = CLPopupDataPickerController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = .yearMonthDayHourMinute
        controller.yearMonthDayHourMinuteCallback = yearMonthDayHourMinuteCallback
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示BMI输入弹窗
    class func showBMIInput(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = true, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, bmiCallback: ((CGFloat) -> ())? = nil) {
        let controller = CLPopupBMIInputController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.bmiCallback = bmiCallback
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示一个输入框弹窗
    class func showOneInput(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = true, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, type: CLPopupOneInputType, sureCallback: ((String?) -> ())? = nil) {
        let controller = CLPopupOneInputController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = type
        controller.sureCallback = sureCallback
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示两个输入框弹窗
    class func showTwoInput(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, displacement: Bool = false, passedDown: Bool = false, type: CLPopupTwoInputType, sureCallback: ((String?, String?) -> ())? = nil) {
        let controller = CLPopupTwoInputController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = type
        controller.sureCallback = sureCallback
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
    ///显示食物选择器
    class func showFoodPicker(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, displacement: Bool = false, passedDown: Bool = false, selectedCallback: ((String, String, String)->())?) {
        let controller = CLPopupFoodPickerController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = false
        controller.interfaceOrientationMask = .portrait
        controller.selectedCallback = selectedCallback
        showCustom(with: controller, displacement: displacement, passedDown: passedDown)
    }
}
