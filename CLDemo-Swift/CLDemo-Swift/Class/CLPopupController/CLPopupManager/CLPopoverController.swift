
import UIKit

// MARK: - 弹窗父类控制器

@objcMembers open class CLPopoverController: UIViewController {
    @available(*, unavailable)
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
    open override var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        set {
            super.overrideUserInterfaceStyle = newValue
        }
        get {
            return .light
        }
    }

    deinit {
    }

    open var config = CLPopoverConfig()

    open var key: String {
        "\(Unmanaged.passUnretained(self).toOpaque())"
    }
}

extension CLPopoverController {
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension CLPopoverController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return config.statusBarStyle
    }

    open override var prefersStatusBarHidden: Bool {
        return config.isHiddenStatusBar
    }

    open override var shouldAutorotate: Bool {
        return config.isAutorotate
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
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
