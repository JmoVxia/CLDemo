//
//  swift
//  FUSHENG
//
//  Created by JmoVxia on 2019/12/24.
//  Copyright © 2019 FuSheng. All rights reserved.
//

import UIKit
import DateToolsSwift

//MARK: - 弹窗配置
@objcMembers class CLPopupManagerConfigure: NSObject {
    ///唯一标识符
    fileprivate (set) var identifier: String = ""
    ///顶掉前面弹窗弹窗
    var isDisplacement: Bool = false
    ///向下传递手势
    var isPassedDown: Bool = false
    ///是否自动旋转
    var isAutorotate: Bool = false
    ///是否隐藏状态栏
    var isHiddenStatusBar: Bool = false
    ///状态栏颜色
    var statusBarStyle: UIStatusBarStyle = .lightContent
    ///支持方向
    var interfaceOrientationMask: UIInterfaceOrientationMask = .portrait
}
//MARK: - 弹窗父类控制器
@objcMembers class CLPopupManagerController: UIViewController {
    ///配置
    var configure: CLPopupManagerConfigure = CLPopupManagerConfigure()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if let statusBarStyle = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController?.preferredStatusBarStyle {
            configure.statusBarStyle = statusBarStyle
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
//        CLLog("=====  \(self.classForCoder) deinit  =====")
    }
}
extension CLPopupManagerController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return configure.statusBarStyle
    }
    override var shouldAutorotate: Bool {
        return configure.isAutorotate
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return configure.interfaceOrientationMask
    }
    override var prefersStatusBarHidden: Bool {
        return configure.isHiddenStatusBar
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
    deinit {
//        CLLog("=====  \(self.classForCoder) deinit  =====")
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
    private var windowsDictionary = [String : CLPopupManagerWindow]()
    private override init() {
        super.init()
    }
    deinit {
//        CLLog("=====  \(self.classForCoder) deinit  =====")
    }
}
extension CLPopupManager {
    /// 显示自定义弹窗
    private class func showController(_ controller: CLPopupManagerController) {
        DispatchQueue.main.async {
            if controller.configure.isDisplacement {
                share.windowsDictionary.removeAll()
            }
            let window = CLPopupManagerWindow(frame: UIScreen.main.bounds)
            window.isPassedDown = controller.configure.isPassedDown
            window.windowLevel = UIWindow.Level.statusBar
            window.isUserInteractionEnabled = true
            window.rootViewController = controller
            window.makeKeyAndVisible()
            share.windowsDictionary[controller.configure.identifier] = window
        }
    }
    /// 隐藏所有弹窗
    class func dismissAll() {
        DispatchQueue.main.async {
            share.windowsDictionary.removeAll()
            manager = nil
        }
    }
    ///隐藏指定弹窗
    class func dismiss(_ identifier : String) {
        DispatchQueue.main.async {
            share.windowsDictionary.removeValue(forKey: identifier)
            if share.windowsDictionary.isEmpty {
                dismissAll()
            }
        }
    }
}
extension CLPopupManager {
    /// 显示翻牌弹窗
    @discardableResult class func showFlop(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil) -> String{
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupFlopController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            showController(controller)
        }
        return identifier
    }
    /// 显示可拖拽弹窗
    @discardableResult class func showDrag(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil) -> String{
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupMomentumController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            showController(controller)
        }
        return identifier
    }
    ///显示提示弹窗
    @discardableResult class func showTips(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, text: String, dismissInterval: TimeInterval = 1.0, dissmissCallBack: (() -> ())? = nil) -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupTipsController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.text = text
            controller.dismissInterval = dismissInterval
            controller.dissmissCallBack = dissmissCallBack
            showController(controller)
        }
        return identifier
    }
    ///显示一个消息弹窗
    @discardableResult class func showOneAlert(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, title: String? = nil, message: String? = nil, sure: String = "确定", sureCallBack: (() -> ())? = nil) -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupMessageController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.type = .one
            controller.titleLabel.text = title
            controller.messageLabel.text = message
            controller.sureButton.setTitle(sure, for: .normal)
            controller.sureButton.setTitle(sure, for: .selected)
            controller.sureButton.setTitle(sure, for: .highlighted)
            controller.sureCallBack = sureCallBack
            showController(controller)
        }
        return identifier
    }
    ///显示两个消息弹窗
    @discardableResult class func showTwoAlert(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, title: String? = nil, message: String? = nil, left: String = "取消", right: String = "确定", leftCallBack: (() -> ())? = nil, rightCallBack: (() -> ())? = nil) -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupMessageController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
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
            showController(controller)
        }
        return identifier
    }
    ///显示成功
    @discardableResult class func showSuccess(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, strokeColor: UIColor = UIColor.red, text: String? = nil, dismissDuration: CGFloat = 1.0, dismissCallback: (() -> ())? = nil) -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupHudController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.animationType = .success
            controller.strokeColor = strokeColor
            controller.text = text
            controller.dismissDuration = dismissDuration
            controller.dismissCallback = dismissCallback
            showController(controller)
        }
        return identifier
    }
    ///显示错误
    @discardableResult class func showError(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, strokeColor: UIColor = .red, text: String? = nil, dismissDuration: CGFloat = 1.0, dismissCallback: (() -> ())? = nil) -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupHudController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.animationType = .error
            controller.strokeColor = strokeColor
            controller.text = text
            controller.dismissDuration = dismissDuration
            controller.dismissCallback = dismissCallback
            showController(controller)
        }
        return identifier
    }
    ///显示加载动画
    @discardableResult class func showHudLoading(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, strokeColor: UIColor = .red, text: String? = nil) -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupHudController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.animationType = .loading
            controller.strokeColor = strokeColor
            controller.text = text
            controller.animationSize = CGSize(width: 80, height: 80)
            showController(controller)
        }
        return identifier
    }
    ///显示年月日选择器
    @discardableResult class func showYearMonthDayDataPicker(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, minDate: Date = Date().subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 10)), maxDate: Date = Date(), yearMonthDayCallback: ((Int, Int, Int) -> ())? = nil) -> String{
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupDataPickerController()
            controller.minDate = minDate
            controller.maxDate = maxDate
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.type = .yearMonthDay
            controller.yearMonthDayCallback = yearMonthDayCallback
            showController(controller)
        }
        return identifier
    }
    ///显示时分选择器
    @discardableResult class func showHourMinuteDataPicker(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, hourMinuteCallback: ((Int, Int) -> ())? = nil) -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupDataPickerController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.type = .hourMinute
            controller.hourMinuteCallback = hourMinuteCallback
            showController(controller)
        }
        return identifier
    }
    ///显示年月日时分选择器
    @discardableResult class func showYearMonthDayHourMinuteDataPicker(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, yearMonthDayHourMinuteCallback: ((Int, Int, Int, Int, Int) -> ())? = nil) -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupDataPickerController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.type = .yearMonthDayHourMinute
            controller.yearMonthDayHourMinuteCallback = yearMonthDayHourMinuteCallback
            showController(controller)
        }
        return identifier
    }
    ///显示时长选择器
    @discardableResult class func showDurationDataPicker(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, durationCallback: ((String, String) -> ())? = nil)  -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupDataPickerController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.type = .duration
            controller.durationCallback = durationCallback
            showController(controller)
        }
        return identifier
    }
    ///显示一个选择器
    @discardableResult class func showOnePicker(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, dataSource: [String], unit: String? = nil, space: CGFloat = -10, selectedCallback: ((String) -> ())? = nil)  -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupDataPickerController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.type = .one
            controller.unit = unit
            controller.space = space
            controller.dataSource = dataSource
            controller.selectedCallback = selectedCallback
            showController(controller)
        }
        return identifier
    }
    ///显示BMI输入弹窗
    @discardableResult class func showBMIInput(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, bmiCallback: ((CGFloat) -> ())? = nil)  -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupBMIInputController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.bmiCallback = bmiCallback
            showController(controller)
        }
        return identifier
    }
    ///显示一个输入框弹窗
    @discardableResult class func showOneInput(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, type: CLPopupOneInputType, sureCallback: ((String?) -> ())? = nil)  -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupOneInputController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.type = type
            controller.sureCallback = sureCallback
            showController(controller)
        }
        return identifier
    }
    ///显示两个输入框弹窗
    @discardableResult class func showTwoInput(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, type: CLPopupTwoInputType, sureCallback: ((String?, String?) -> ())? = nil)  -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupTwoInputController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.type = type
            controller.sureCallback = sureCallback
            showController(controller)
        }
        return identifier
    }
    ///显示食物选择器
    @discardableResult class func showFoodPicker(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil, selectedCallback: ((String, String, String, String)->())?)  -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupFoodPickerController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            controller.selectedCallback = selectedCallback
            showController(controller)
        }
        return identifier
    }
    ///显示加载动画
    @discardableResult class func showLoading(configureCallback: ((CLPopupManagerConfigure) -> ())? = nil) -> String {
        let identifier: String = dateRandomString
        DispatchQueue.main.async {
            let controller = CLPopupLoadingController()
            controller.configure.identifier = identifier
            configureCallback?(controller.configure)
            showController(controller)
        }
        return identifier
    }
}
