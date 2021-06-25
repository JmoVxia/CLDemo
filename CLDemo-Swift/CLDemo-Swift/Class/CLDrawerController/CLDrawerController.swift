//
//  CLDrawerController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/3/23.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit


//MARK: - JmoVxia---类-属性
class CLDrawerController: CLController {
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
extension CLDrawerController {
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
private extension CLDrawerController {
    func initUI() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        button.setTitleColor(.black, for: .normal)
        button.setTitle("点我", for: .normal)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func makeConstraints() {
    }
    @objc func click() {
        let controller = CLDrawerTestController()
        present(controller, animated: true)
    }
}
