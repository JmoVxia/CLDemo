//
//  CLCalendarController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2022/10/19.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---枚举

extension CLCalendarController {}

// MARK: - JmoVxia---类-属性

class CLCalendarController: CLController {
    private lazy var button: UIButton = {
        let view = UIButton()
        view.setTitle("打开日历", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        view.addTarget(self, action: #selector(calendarClick), for: .touchUpInside)
        return view
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}
}

// MARK: - JmoVxia---生命周期

extension CLCalendarController {
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

// MARK: - JmoVxia---布局

private extension CLCalendarController {
    func configUI() {
        view.addSubview(button)
    }

    func makeConstraints() {
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLCalendarController {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLCalendarController {}

// MARK: - JmoVxia---objc

@objc private extension CLCalendarController {
    func calendarClick() {
        let controller = CLCalendarViewController()
//        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
}

// MARK: - JmoVxia---私有方法

private extension CLCalendarController {}

// MARK: - JmoVxia---公共方法

extension CLCalendarController {}
