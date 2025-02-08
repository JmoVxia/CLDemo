//
//  CLPopoverController.swift
//
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
        let keyWindow = if #available(iOS 13.0, *) {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .first { $0.isKeyWindow }
        } else {
            UIApplication.shared.keyWindow
        }
        if let prefersStatusBarHidden = keyWindow?.rootViewController?.prefersStatusBarHidden {
            config.prefersStatusBarHidden = prefersStatusBarHidden
        }
        if let preferredStatusBarStyle = keyWindow?.rootViewController?.preferredStatusBarStyle {
            config.preferredStatusBarStyle = preferredStatusBarStyle
        }
        if let supportedInterfaceOrientations = keyWindow?.rootViewController?.supportedInterfaceOrientations {
            config.supportedInterfaceOrientations = supportedInterfaceOrientations
        }
    }

    open var config = CLPopoverConfig()

    open var key: String {
        "\(Unmanaged.passUnretained(self).toOpaque())"
    }
}

extension CLPopoverController {
    @available(iOS 13.0, *)
    override open var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        set {
            super.overrideUserInterfaceStyle = newValue
        }
        get {
            .init(rawValue: config.userInterfaceStyleOverride.rawValue) ?? .light
        }
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
        config.preferredStatusBarStyle
    }

    override open var prefersStatusBarHidden: Bool {
        config.prefersStatusBarHidden
    }

    override open var shouldAutorotate: Bool {
        config.shouldAutorotate
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        config.supportedInterfaceOrientations
    }
}
