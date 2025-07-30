//
//  CLLogController.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2025/7/29.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---类-属性

class CLLogController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var logView: CLLogView = {
        let view = CLLogView()
        view.backgroundColor = .orange.withAlphaComponent(0.4)
        return view
    }()

    deinit {}
}

// MARK: - JmoVxia---生命周期

extension CLLogController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstraints()
        configData()
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for i in 0 ... 100 {
            CLLog("test \(i)")
        }
    }
}

// MARK: - JmoVxia---布局

private extension CLLogController {
    func setupUI() {
        view.addSubview(logView)
    }

    func makeConstraints() {
        logView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLLogController {
    func configData() {}
}

// MARK: - JmoVxia---override

extension CLLogController {}

// MARK: - JmoVxia---objc

@objc private extension CLLogController {}

// MARK: - JmoVxia---私有方法

private extension CLLogController {}

// MARK: - JmoVxia---公共方法

extension CLLogController {}
