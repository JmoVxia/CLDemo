//
//  CLDarkModeController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/15.
//

import UIKit
import SnapKit


//MARK: - JmoVxia---类-属性
class CLDarkModeController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    private lazy var topImageView: UIImageView = {
        let view = UIImageView()
        view.image = .image(light: UIImage(named: "orangeCat")!, dark: UIImage(named: "Hamster")!)
        return view
    }()

    private lazy var followButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .color(light: .gray, dark: .black)
        view.titleLabel?.font = PingFangSCMedium(18)
        view.setTitle("Follow", for: .normal)
        view.setTitle("Follow", for: .selected)
        view.setTitle("Follow", for: .highlighted)
        view.setTitleColor(.color(light: .black, dark: .white), for: .normal)
        view.setTitleColor(.color(light: .black, dark: .white), for: .normal)
        view.setTitleColor(.color(light: .black, dark: .white), for: .normal)
        view.addTarget(self, action: #selector(followAction), for: .touchUpInside)
        return view
    }()
    private lazy var lightButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .color(light: .gray, dark: .black)
        view.titleLabel?.font = PingFangSCMedium(18)
        view.setTitle("light", for: .normal)
        view.setTitle("light", for: .selected)
        view.setTitle("light", for: .highlighted)
        view.setTitleColor(.color(light: .black, dark: .white), for: .normal)
        view.setTitleColor(.color(light: .black, dark: .white), for: .normal)
        view.setTitleColor(.color(light: .black, dark: .white), for: .normal)
        view.addTarget(self, action: #selector(lightAction), for: .touchUpInside)
        return view
    }()
    private lazy var darkButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .color(light: .gray, dark: .black)
        view.titleLabel?.font = PingFangSCMedium(18)
        view.setTitle("Dark", for: .normal)
        view.setTitle("Dark", for: .selected)
        view.setTitle("Dark", for: .highlighted)
        view.setTitleColor(.color(light: .black, dark: .white), for: .normal)
        view.setTitleColor(.color(light: .black, dark: .white), for: .normal)
        view.setTitleColor(.color(light: .black, dark: .white), for: .normal)
        view.addTarget(self, action: #selector(darkAction), for: .touchUpInside)
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLDarkModeController {
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
private extension CLDarkModeController {
    func initUI() {
        updateTitleLabel { (label) in
            label.text = "夜间模式".localized
        }
        view.addSubview(topImageView)
        view.addSubview(followButton)
        view.addSubview(lightButton)
        view.addSubview(darkButton)
    }
    func makeConstraints() {
        topImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
            make.bottom.equalTo(lightButton.snp.top).offset(-50)
        }
        followButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
            make.width.equalTo(UIScreen.main.bounds.width / 4)
        }
        lightButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
            make.width.equalTo(UIScreen.main.bounds.width / 4)
        }
        darkButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
            make.width.equalTo(UIScreen.main.bounds.width / 4)
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLDarkModeController {
}
//MARK: - JmoVxia---override
extension CLDarkModeController {
}
//MARK: - JmoVxia---objc
@objc private extension CLDarkModeController {
    func followAction() {
        CLTheme.mode = .follow
        change()
    }
    func lightAction() {
        CLTheme.mode = .light
        change()
    }
    func darkAction() {
        CLTheme.mode = .dark
        change()
    }
    func change() {
        guard let window = UIApplication.shared.keyWindow else { return }
        if #available(iOS 13.0, *) { // 区分版本
            UIView.transition (with: window, duration: 0.5, options: .transitionCrossDissolve, animations: { // 增加转场动画
                window.overrideUserInterfaceStyle = CLTheme.mode.style // 重置系统模式
            })
        } else {
            let tabbarController = CLTabBarController()
            tabbarController.tabBar.isHidden = true
            tabbarController.selectedIndex = 0
            let navController = tabbarController.selectedViewController as? CLNavigationController
            let viewControllers = navController?.viewControllers
            let homeController = viewControllers?.first as? CLHomePageController
            let darkModeController = CLDarkModeController()
            
            DispatchQueue.main.async {
                UIView.transition(from: self.view, to: darkModeController.view, duration: 0.5, options: .transitionCrossDissolve) { _ in
                    window.rootViewController = tabbarController
                    homeController?.navigationController?.pushViewController(darkModeController, animated: false)
                }
            }
        }
    }
}
