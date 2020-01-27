//
//  PopupViewManager.swift
//  FUSHENG
//
//  Created by JmoVxia on 2019/12/24.
//  Copyright © 2019 FuSheng. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    ///状态栏颜色
    var statusBarStyle: UIStatusBarStyle = UIApplication.shared.statusBarStyle {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    ///是否自动旋转
    var autorotate: Bool = false
    ///支持方向
    var interfaceOrientationMask: UIInterfaceOrientationMask = .portrait
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    override var shouldAutorotate: Bool {
        return autorotate
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientationMask
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}
class PopupViewWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == rootViewController?.view {
            return nil
        }
        return view
    }
}
class PopupViewManager: NSObject {
    private static var manager: PopupViewManager?
    private class var share: PopupViewManager {
        get {
            guard let shareManager = manager else {
                manager = PopupViewManager()
                return manager!
            }
            return shareManager
        }
    }
    
    private var showWindow: PopupViewWindow?
    private class var window: PopupViewWindow {
        get {
            guard let window = PopupViewManager.share.showWindow else {
                PopupViewManager.share.showWindow = PopupViewWindow(frame: UIScreen.main.bounds)
                PopupViewManager.share.showWindow!.windowLevel = UIWindow.Level.statusBar
                PopupViewManager.share.showWindow!.isUserInteractionEnabled = true
                PopupViewManager.share.showWindow?.rootViewController = PopupViewController()
                return PopupViewManager.share.showWindow!
            }
            return window
        }
    }
    private override init() {
        super.init()
    }
    deinit {
        print("============== PopupViewManager deinit ==================")
    }
}
extension PopupViewManager {
    private class func makeKeyAndVisible(controller: UIViewController, only: Bool) {
        let rootViewController = PopupViewManager.window.rootViewController
        if let children = rootViewController?.children, only {
            for childrenController in children {
                childrenController.willMove(toParent: nil)
                childrenController.view.removeFromSuperview()
                childrenController.removeFromParent()
            }
        }
        controller.modalPresentationStyle = .custom
        rootViewController?.addChild(controller)
        rootViewController?.view.addSubview(controller.view)
        controller.didMove(toParent: rootViewController)
        PopupViewManager.window.makeKeyAndVisible()
    }
    private class func destroy(all: Bool = false) {
        guard let childrenController = PopupViewManager.window.rootViewController?.children else {
            return
        }
        let controller = childrenController.last
        controller?.willMove(toParent: nil)
        controller?.view.removeFromSuperview()
        controller?.removeFromParent()
        if childrenController.count == 1 || all {
            PopupViewManager.window.resignKey()
            PopupViewManager.window.isHidden = true
            PopupViewManager.share.showWindow = nil
            manager = nil
        }
    }
}
extension PopupViewManager {
    
    /// 显示自定义弹窗
    /// - Parameters:
    ///   - controller: 自动有弹窗控制器
    ///   - only: 唯一弹窗
    class func showCustom(controller: UIViewController, only: Bool = false) {
        makeKeyAndVisible(controller: controller, only: only)
    }
    
    /// 显示翻牌弹窗
    /// - Parameters:
    ///   - statusBarStyle: 状态栏样式
    ///   - autorotate: 自动旋转
    ///   - interfaceOrientationMask: 旋转支持方向
    ///   - only: 唯一弹窗
    class func showFlop(statusBarStyle: UIStatusBarStyle = .lightContent, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .portrait, only: Bool = false) {
        let controller = FlopController()
        controller.statusBarStyle = statusBarStyle
        controller.autorotate = true
        controller.interfaceOrientationMask = interfaceOrientationMask
        showCustom(controller: controller, only: only)
    }
    /// 隐藏弹窗
    /// - Parameter all: 全部弹窗
    class func dismiss(all: Bool = false) {
        PopupViewManager.destroy(all: all)
    }
}
