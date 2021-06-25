//
//  CLController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/6/22.
//

import UIKit


//MARK: - JmoVxia---类-属性
class CLController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        CLLog("\(self.classForCoder) deinit")
    }
    ///自定义返回响应
    var customBackActionCallback: (() -> (Bool))? {
        didSet {
            (navigationController as? CLNavigationController)?.customBackActionCallback = customBackActionCallback
        }
    }
    ///是否允许侧滑
    var isCanSideBack: Bool = true
    ///状态栏颜色
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            if oldValue != statusBarStyle {
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    ///是否隐藏状态栏
    var isHiddenStatusBar: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    ///导航条高度
    var navigationBarHeight: CGFloat {
        return navigationController?.navigationBar.bounds.height ?? 0
    }
    ///顶部文字
    var titleText: String? {
        return titleLabel.text
    }
    ///转子标识符
    private var identifier: String?
    private lazy var titleLabel: UILabel = {
       let view = UILabel()
        view.font = PingFangSCBold(18)
        view.textColor = .hex("333333")
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
//MARK: - JmoVxia---布局
private extension CLController {
    func initUI() {
        view.backgroundColor = .white
        navigationItem.titleView = titleLabel
        let target = navigationController?.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer.init(target: target, action: Selector(("handleNavigationTransition:")))
        pan.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.addGestureRecognizer(pan)
    }
    func makeConstraints() {
    }
}
//MARK: - JmoVxia---override
extension CLController {
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    override var prefersStatusBarHidden: Bool {
        return isHiddenStatusBar
    }
    @available(iOS 13.0, *) override var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        set {
            
        }
        get {
            return .light
        }
    }
}
//MARK: - JmoVxia---公共方法
extension CLController {
    ///更新顶部label
    func updateTitleLabel(_ viewCallback:@escaping ((UILabel) -> ())) {
        DispatchQueue.main.async {
            viewCallback(self.titleLabel)
            self.titleLabel.sizeToFit()
        }
    }
    ///显示加载动画
    func showProgress() {
        identifier = CLPopupManager.showLoading()
    }
    ///隐藏加载动画
    func hiddenProgress() {
        guard let identifier = identifier else { return }
        CLPopupManager.dismiss(identifier)
    }
    ///返回
    func back() {
        (navigationController as? CLNavigationController)?.backItemAction()
    }
}
//MARK: - JmoVxia---UIGestureRecognizerDelegate
extension CLController :UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if isCanSideBack {
            let isResponds: Bool = navigationController?.interactivePopGestureRecognizer?.delegate?.responds(to: Selector(("handleNavigationTransition:"))) ?? false
            if  isResponds {
                let count = navigationController?.children.count ?? 0
                return count > 1
            }
        }else {
            return false
        }
        return false
    }
}
