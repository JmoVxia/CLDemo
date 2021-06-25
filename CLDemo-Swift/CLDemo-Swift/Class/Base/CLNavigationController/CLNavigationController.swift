//
//  CLNavigationController.swift
//  CL
//
//  Created by Chen JmoVxia on 2020/10/16.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit


//MARK: - JmoVxia---类-属性
class CLNavigationController: UINavigationController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    ///自定义返回响应
    var customBackActionCallback: (() -> (Bool))?
    private lazy var backItem: CLBackView = {
        let view = CLBackView()
        view.title = "    ".localized
        view.addTarget(self, action: #selector(backItemAction), for: .touchUpInside)
       return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLNavigationController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
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
private extension CLNavigationController {
    func initUI() {
        view.backgroundColor = .white
        UINavigationBar.appearance().tintColor = .white
    }
}
//MARK: - JmoVxia---override
extension CLNavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backItem)
        }
        super.pushViewController(viewController, animated: animated)
    }
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if !viewControllers.isEmpty {
            viewControllers.last?.hidesBottomBarWhenPushed = true
            viewControllers.last?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backItem)
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
    // 是否支持自动转屏
    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }
    // 支持哪些屏幕方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    // 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    ///状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    ///是否隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? false
    }
    @available(iOS 13.0, *)
    override var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        set {
            
        }
        get {
            return topViewController?.overrideUserInterfaceStyle ?? .light
        }
    }
}
//MARK: - JmoVxia---objc
@objc extension CLNavigationController {
    func backItemAction() {
        let isCustomBack = customBackActionCallback?() ?? false
        if !isCustomBack {
            if presentingViewController != nil, viewControllers.count == 1 {
                dismiss(animated: true)
            }else {
                popViewController(animated: true)
            }
        }
    }
}
