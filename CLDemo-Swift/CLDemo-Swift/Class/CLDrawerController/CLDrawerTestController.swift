//
//  CLDrawerTestController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/3/23.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit


//MARK: - JmoVxia---类-属性
class CLDrawerTestController: CLController {
    let transitionManager = CLDrawerTransitionDelegate()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionManager
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
}
//MARK: - JmoVxia---生命周期
extension CLDrawerTestController {
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
private extension CLDrawerTestController {
    func initUI() {
    }
    func makeConstraints() {
    }
}
