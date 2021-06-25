//
//  CLChangeLanguageController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/6/22.
//

import UIKit


//MARK: - JmoVxia---枚举
extension CLChangeLanguageController {
}
//MARK: - JmoVxia---类-属性
class CLChangeLanguageController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    private lazy var tableViewHepler: CLTableViewHepler = {
        let hepler = CLTableViewHepler()
        return hepler
    }()
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.dataSource = tableViewHepler
        view.delegate = tableViewHepler
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLChangeLanguageController {
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
        initData()
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
private extension CLChangeLanguageController {
    func initUI() {
        updateTitleLabel { label in
            label.text = "切换语言".localized
        }
        view.addSubview(tableView)
    }
    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarHeight + statusBarHeight)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLChangeLanguageController {
    func initData() {
        do{
            let item = CLTitleCellItem(title: "跟随系统".localized, type: CLChangeLanguageController.self)
            item.accessoryType = CLLanguageManager.shared.currentLanguage == .system ? .checkmark : .none
            item.didSelectCellCallback = {[weak self] (value) in
                guard let self = self else { return }
                self.changeLanguage(.system)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "中文".localized, type: CLChangeLanguageController.self)
            item.accessoryType = CLLanguageManager.shared.currentLanguage == .chineseSimplified ? .checkmark : .none
            item.didSelectCellCallback = {[weak self] (value) in
                guard let self = self else { return }
                self.changeLanguage(.chineseSimplified)
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLTitleCellItem(title: "英文".localized, type: CLChangeLanguageController.self)
            item.accessoryType = CLLanguageManager.shared.currentLanguage == .english ? .checkmark : .none
            item.didSelectCellCallback = {[weak self] (value) in
                guard let self = self else { return }
                self.changeLanguage(.english)
            }
            tableViewHepler.dataSource.append(item)
        }
        tableView.reloadData()
    }
}
//MARK: - JmoVxia---私有方法
private extension CLChangeLanguageController {
    func changeLanguage(_ language: CLLanguageManager.Language) {
        guard CLLanguageManager.shared.currentLanguage != language else { return }
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }

        CLLanguageManager.setUserLanguage(language)

        let tabbarController = CLTabBarController()
        tabbarController.selectedIndex = 0
        
        guard let navigationController = (tabbarController.selectedViewController as? CLNavigationController) else { return }
        var viewControllers = navigationController.viewControllers
        viewControllers.append(CLChangeLanguageController())
        
        DispatchQueue.main.async {
            delegate.window?.rootViewController = tabbarController
            navigationController.viewControllers = viewControllers
        }
    }
}

