//
//  CLTagsController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/20.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---枚举
extension CLTagsController {
}
//MARK: - JmoVxia---类-属性
class CLTagsController: CLController {
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
        view.dataSource = tableViewHepler
        view.delegate = tableViewHepler
        view.backgroundColor = .clear
        view.separatorStyle = .none
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        }
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLTagsController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
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
private extension CLTagsController {
    func configUI() {
        view.addSubview(tableView)
    }
    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLTagsController {
    func initData() {
        do {
            let item = CLTitleCellItem(title: "计算位置实现".localized, type: CLTagsCalculateController.self)
            item.accessoryType = .disclosureIndicator
            item.didSelectCellCallback = {[weak self, weak item] (value) in
                guard let self = self, let item = item else { return }
                self.push(item.type, title: item.title)
            }
            tableViewHepler.rows.append(item)
        }
        tableView.reloadData()
    }
}
//MARK: - JmoVxia---override
extension CLTagsController {
}
//MARK: - JmoVxia---objc
@objc private extension CLTagsController {
}
//MARK: - JmoVxia---私有方法
private extension CLTagsController {
    func push(_ type: CLController.Type, title: String) {
        CLLog("\(title)---->\(type)")
        let controller = type.init()
        controller.updateTitleLabel { label in
            label.text = title
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}
//MARK: - JmoVxia---公共方法
extension CLTagsController {
}
