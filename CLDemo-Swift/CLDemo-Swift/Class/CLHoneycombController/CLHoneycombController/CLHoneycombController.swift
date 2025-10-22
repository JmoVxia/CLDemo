//
//  CLHoneycombController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/16.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---类-属性

class CLHoneycombController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

    private let tableViewRowManager = CLTableViewRowManager()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = tableViewRowManager
        view.delegate = tableViewRowManager
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

extension CLHoneycombController {
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

private extension CLHoneycombController {
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

private extension CLHoneycombController {
    func initData() {
        do {
            let item = CLTitleCellItem(title: "UICollectionView 实现".localized, type: CLHoneycombCollectionViewController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelect = { [weak self, weak item] value in
                guard let self, let item else { return }
                push(item.type, title: item.title)
            }
            tableViewRowManager.dataSource.append(item)
        }
        do {
            let item = CLTitleCellItem(title: "UIScrollView 实现".localized, type: CLHoneycombScrollViewController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelect = { [weak self, weak item] value in
                guard let self, let item else { return }
                push(item.type, title: item.title)
            }
            tableViewRowManager.dataSource.append(item)
        }
        tableView.reloadData()
    }
}

// MARK: - JmoVxia---override

extension CLHoneycombController {}

// MARK: - JmoVxia---objc

@objc private extension CLHoneycombController {}

// MARK: - JmoVxia---私有方法

private extension CLHoneycombController {
    func push(_ type: CLController.Type, title: String) {
        CLLog("\(title)---->\(type)")
        let controller = type.init()
        controller.updateTitleLabel { label in
            label.text = title
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - JmoVxia---公共方法

extension CLHoneycombController {}
