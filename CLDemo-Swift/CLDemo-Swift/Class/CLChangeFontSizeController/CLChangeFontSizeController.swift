//
//  CLChangeFontSizeController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/15.
//

import SnapKit
import UIKit

class CLChangeFontSizeController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

    private lazy var slider: CLSubsectionSlider = {
        let view = CLSubsectionSlider()
        view.changeCallback = { [weak self] value in
            self?.refresh()
        }
        view.endCallback = { [weak self] value in
            self?.refreshRootController()
        }
        return view
    }()

    private lazy var tableViewHepler: CLTableViewHepler = {
        let hepler = CLTableViewHepler()
        return hepler
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = tableViewHepler
        view.delegate = tableViewHepler
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.estimatedRowHeight = 150
        view.estimatedSectionHeaderHeight = 0
        view.estimatedSectionFooterHeight = 0
        view.contentInset = .zero
        view.contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        }
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        return view
    }()
}

// MARK: - JmoVxia---生命周期

extension CLChangeFontSizeController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
}

// MARK: - JmoVxia---布局

private extension CLChangeFontSizeController {
    func initUI() {
        updateTitleLabel { label in
            label.text = "夜间模式".localized
        }
        view.backgroundColor = UIColor.white
        view.addSubview(slider)
        view.addSubview(tableView)
    }

    func makeConstraints() {
        slider.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(130)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(statusBarHeight + navigationBarHeight)
            make.bottom.equalTo(slider.snp.top)
        }
    }
}

// MARK: - JmoVxia---刷新

private extension CLChangeFontSizeController {
    func refresh() {
        updateTitleLabel { label in
            label.font = .boldPingFangSC(18)
        }
        for item in tableViewHepler.rows {
            if let cellItem = item as? CLChatTextItem {
                let text = cellItem.text
                cellItem.text = text
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func refreshRootController() {
        let tabbarController = CLTabBarController()
        tabbarController.tabBar.isHidden = true
        tabbarController.selectedIndex = 0
        let navController = tabbarController.selectedViewController as? CLNavigationController
        let viewControllers = navController?.viewControllers
        let homeController = viewControllers?.first as? CLHomePageController

        let fontSizeController = CLChangeFontSizeController()
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = tabbarController
            homeController?.navigationController?.pushViewController(fontSizeController, animated: false)
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLChangeFontSizeController {
    func initData() {
        do {
            let item = CLChatTextItem()
            item.isFromMyself = false
            item.text = "预览字体大小"
            item.messageSendState = .sendSucess
            tableViewHepler.rows.append(item)
        }
        do {
            let item = CLChatTextItem()
            item.isFromMyself = true
            item.text = "拖拽或者点击下面的滑块，可设置字体大小"
            item.messageSendState = .sendSucess
            tableViewHepler.rows.append(item)
        }
        do {
            let item = CLChatTextItem()
            item.isFromMyself = true
            item.text = "设置后，可改变APP中的字体大小。如果在使用过程中存在问题或意见，可反馈给我们团队"
            item.messageSendState = .sendSucess
            tableViewHepler.rows.append(item)
        }
        tableView.reloadData()
    }
}
