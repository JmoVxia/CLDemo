//
//  CLPopoverController.swift
//  CKDDoctor
//
//  Created by Chen JmoVxia on 2022/7/8.
//

import UIKit

// MARK: - 弹窗父类控制器

@objcMembers open class CLPopoverController: UIViewController {
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let keyWindow = CLPopoverManager.keyWindow
        if let isHiddenStatusBar = keyWindow?.rootViewController?.prefersStatusBarHidden {
            config.isHiddenStatusBar = isHiddenStatusBar
        }
        if let statusBarStyle = keyWindow?.rootViewController?.preferredStatusBarStyle {
            config.statusBarStyle = statusBarStyle
        }
        if let supportedInterfaceOrientations = keyWindow?.rootViewController?.supportedInterfaceOrientations {
            config.supportedInterfaceOrientations = supportedInterfaceOrientations
        }
    }

    @available(iOS 13.0, *)
    override open var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        set {
            super.overrideUserInterfaceStyle = newValue
        }
        get {
            return .light
        }
    }

    deinit {}

    open var config = CLPopoverConfig()

    open var key: String {
        "\(Unmanaged.passUnretained(self).toOpaque())"
    }
}

extension CLPopoverController {
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension CLPopoverController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return config.statusBarStyle
    }

    override open var prefersStatusBarHidden: Bool {
        return config.isHiddenStatusBar
    }

    override open var shouldAutorotate: Bool {
        return config.isAutorotate
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return config.supportedInterfaceOrientations
    }
}

extension CLPopoverController {
    /// 显示
    open func show() {
        CLPopoverManager.show(self)
    }

    /// 隐藏
    open func hidden() {
        CLPopoverManager.hidden(key)
    }
}
