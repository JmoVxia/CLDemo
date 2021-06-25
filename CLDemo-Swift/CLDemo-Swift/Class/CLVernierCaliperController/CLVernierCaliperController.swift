//
//  CLVernierCaliperController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/6/24.
//

import UIKit

//MARK: - JmoVxia---枚举
extension CLVernierCaliperController {
}
//MARK: - JmoVxia---类-属性
class CLVernierCaliperController: CLController {
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
extension CLVernierCaliperController {
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
private extension CLVernierCaliperController {
    func initUI() {
        view.addSubview(tableView)
    }
    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.left.right.equalToSuperview()
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLVernierCaliperController {
    func initData() {
        do {
            let item = CLRecordVernierCaliperItem()
            item.type = .glucose
            item.title = "血糖值"
            item.unit = "mmHg"
            item.gap = 8
            item.value = 6
            item.minValue = 1
            item.maxValue = 20
            item.minimumUnit = 0.1
            item.unitInterval = 10
            item.valueBackgroundViewSize = CGSize(width: 130, height: 40)
            item.valueChangeCallback = { (value) in
                CLLog("血糖\(value)")
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLRecordVernierCaliperItem()
            item.type = .heartRate
            item.title = "心率次数"
            item.unit = "次/分"
            item.gap = 8
            item.value = 80
            item.minValue = 20
            item.maxValue = 200
            item.minimumUnit = 1
            item.unitInterval = 10
            item.valueChangeCallback = { (value) in
                CLLog("心率次数\(value)")
            }
            tableViewHepler.dataSource.append(item)
        }
        do{
            let item = CLRecordVernierCaliperItem()
            item.type = .temperature
            item.title = "测量体温"
            item.unit = "℃"
            item.gap = 8
            item.value = 36.5
            item.minValue = 25
            item.maxValue = 45
            item.minimumUnit = 0.1
            item.unitInterval = 10
            item.valueChangeCallback = { (value) in
                CLLog("体温\(value)")
            }
            tableViewHepler.dataSource.append(item)
        }
        tableView.reloadData()
    }
}
