//
//  CLCustomTransitionController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/14.
//

import UIKit

// MARK: - JmoVxia---类-属性

class CLCustomTransitionController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

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

extension CLCustomTransitionController {
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

// MARK: - JmoVxia---布局

private extension CLCustomTransitionController {
    func initUI() {
        view.addSubview(tableView)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLCustomTransitionController {
    func initData() {
        do {
            let item = CLTitleCellItem(title: "气泡".localized, type: CLBubbleTransitionController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = { [weak self, weak item] value in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.rows.append(item)
        }
        do {
            let item = CLTitleCellItem(title: "圆形".localized, type: CLCircleRetroTransitionController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = { [weak self, weak item] value in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.rows.append(item)
        }
        do {
            let item = CLTitleCellItem(title: "翻盖".localized, type: CLTiledFlipRetroTransitionController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = { [weak self, weak item] value in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.rows.append(item)
        }
    }
}

// MARK: - JmoVxia---override

extension CLCustomTransitionController {}

// MARK: - JmoVxia---objc

@objc private extension CLCustomTransitionController {}

// MARK: - JmoVxia---私有方法

private extension CLCustomTransitionController {
    func push(_ type: CLController.Type, title: String) {
        let controller = type.init()
        controller.updateTitleLabel { label in
            label.text = title
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - JmoVxia---公共方法

extension CLCustomTransitionController {}
