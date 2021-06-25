//
//  CKDTabBarController.swift
//  CKD
//
//  Created by Chen JmoVxia on 2020/10/16.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---类-属性
class CLTabBarController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    private lazy var tabbar: CLCustomTabbar = {
        let view = CLCustomTabbar()
        view.bulgeCallBack = {[weak self] (value) in
            guard let self = self else { return }
            self.selectedIndex = 2
            self.tabBar(self.tabbar, didSelect: value)
        }
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLTabBarController {
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
//MARK: - JmoVxia---布局
private extension CLTabBarController {
    func initUI() {
        setValue(tabbar, forKey: "tabBar")
        addChild(CLHomePageController(), title: "首页".localized, image: UIImage(named: "index"), selectedImage: UIImage(named: "indenxHover"))
        addChild(CLChatContactController(), title: "咨询".localized, image: UIImage(named: "advisoty"), selectedImage: UIImage(named: "advisotyHover"))
        addChild(CLRecordController(), title: "记录".localized, image: UIImage(named: "task01"), selectedImage: UIImage(named: "task"))
        addChild(CLMealController(), title: "营养".localized, image: UIImage(named: "meal"), selectedImage: UIImage(named: "mealHover"))
        addChild(CLMeController(), title: "我的".localized, image: UIImage(named: "me"), selectedImage: UIImage(named: "meHover"))
    }
}
//MARK: - JmoVxia---override
extension CLTabBarController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items?.firstIndex(of: item) ?? 0
        animationItem(with: index)
    }
    override var shouldAutorotate: Bool {
        if let navigationController = selectedViewController as? UINavigationController {
            return navigationController.topViewController?.shouldAutorotate ?? false
        } else {
            return selectedViewController?.shouldAutorotate ?? false
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let navigationController = selectedViewController as? UINavigationController {
            return navigationController.topViewController?.supportedInterfaceOrientations ?? .portrait
        } else {
            return selectedViewController?.supportedInterfaceOrientations ?? .portrait
        }
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let navigationController = selectedViewController as? UINavigationController {
            return navigationController.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
        } else {
            return selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let navigationController = selectedViewController as? UINavigationController {
            return navigationController.topViewController?.preferredStatusBarStyle ?? .`default`
        } else {
            return selectedViewController?.preferredStatusBarStyle ?? .`default`
        }
    }
    override var prefersStatusBarHidden: Bool {
        if let navigationController = selectedViewController as? UINavigationController {
            return navigationController.topViewController?.prefersStatusBarHidden ?? false
        } else {
            return selectedViewController?.prefersStatusBarHidden ?? false
        }
    }
    @available(iOS 13.0, *) override var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        set {
            
        }
        get {
            if let navigationController = selectedViewController as? UINavigationController {
                return navigationController.topViewController?.overrideUserInterfaceStyle ?? .light
            } else {
                return selectedViewController?.overrideUserInterfaceStyle ?? .light
            }
        }
    }
}
//MARK: - JmoVxia---私有方法
private extension CLTabBarController {
    func addChild(_ child: UIViewController, title: String, image: UIImage?, selectedImage: UIImage?) {
        child.title = title
        child.tabBarItem.setTitleTextAttributes([.font : PingFangSCBold(11), .foregroundColor : UIColor.hex("333333")], for: .normal)
        child.tabBarItem.setTitleTextAttributes([.font : PingFangSCBold(11), .foregroundColor : UIColor.hex("666666")], for: .selected)
        child.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        child.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        let navController = CLNavigationController(rootViewController: child)
        addChild(navController)
    }
    func animationItem(with index: Int) {
        if let `class` = NSClassFromString("UITabBarButton") {
            let view = tabBar.subviews.filter({$0.isKind(of: `class`)})[index]
            let animation = CASpringAnimation(keyPath: "transform.scale")
            animation.mass = 0.6
            animation.stiffness = 80
            animation.damping = 10
            animation.initialVelocity = 0.5
            animation.duration = 0.35
            animation.fromValue = 0.25
            animation.toValue = 1
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.6, 0.1, 0.30, 0.90)
            view.layer.add(animation, forKey: nil)
        }
    }
}
