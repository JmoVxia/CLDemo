//
//  CLCalendarViewController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---枚举
extension CLCalendarViewController {
}
//MARK: - JmoVxia---类-属性
class CLCalendarViewController: CLController {
    private lazy var calendarView: CLCalendarView = {
        let view = CLCalendarView(frame: .zero)
        view.delegate = self
        return view
    }()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
}
//MARK: - JmoVxia---生命周期
extension CLCalendarViewController {
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
private extension CLCalendarViewController {
    func configUI() {
        view.backgroundColor = .white
        view.addSubview(calendarView)
    }
    func makeConstraints() {
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLCalendarViewController {
    func initData() {
    }
}
//MARK: - JmoVxia---override
extension CLCalendarViewController {
}
//MARK: - JmoVxia---objc
@objc private extension CLCalendarViewController {
}
//MARK: - JmoVxia---私有方法
private extension CLCalendarViewController {
}
//MARK: - JmoVxia---公共方法
extension CLCalendarViewController {
}

extension CLCalendarViewController: CLCalendarDelegate {
    func didSelectArea(begin: Date, end: Date, in view: CLCalendarView) {
        print("beginTime: \(begin), endTime: \(end)")
    }

    func didSelectSingle(date: Date, in view: CLCalendarView) {
        print("date: \(date)")
    }
}
