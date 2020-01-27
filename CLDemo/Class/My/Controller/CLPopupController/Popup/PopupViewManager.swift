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
    
    private var showWindow: UIWindow?
    private class var window: UIWindow {
        get {
            guard let window = PopupViewManager.share.showWindow else {
                PopupViewManager.share.showWindow = UIWindow(frame: UIScreen.main.bounds)
                PopupViewManager.share.showWindow!.windowLevel = UIWindow.Level.statusBar
                PopupViewManager.share.showWindow!.isUserInteractionEnabled = true
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
    private class func makeKeyAndVisible(_ rootViewController: UIViewController) {
        PopupViewManager.window.rootViewController = rootViewController
        PopupViewManager.window.makeKeyAndVisible()
    }
    private class func destroy() {
        PopupViewManager.window.resignKey()
        PopupViewManager.window.isHidden = true
        PopupViewManager.share.showWindow = nil
        manager = nil
    }
}
extension PopupViewManager {
    ///显示自定义弹窗
    class func showCustom(controller: UIViewController) {
        makeKeyAndVisible(controller)
    }
    ///显示翻牌
    class func showFlop(statusBarStyle: UIStatusBarStyle = .lightContent, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .portrait, clickCallBack: (() -> ())? = nil) {
        let rootViewController = FlopController()
        rootViewController.statusBarStyle = statusBarStyle
        rootViewController.autorotate = true
        rootViewController.interfaceOrientationMask = interfaceOrientationMask
        makeKeyAndVisible(rootViewController)
    }
    ///隐藏
    class func dismiss() {
        PopupViewManager.destroy()
    }
}
