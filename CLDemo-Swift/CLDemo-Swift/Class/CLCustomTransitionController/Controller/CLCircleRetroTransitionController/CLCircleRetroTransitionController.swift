//
//  CLCircleRetroTransitionController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/16.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---枚举
extension CLCircleRetroTransitionController {
}
//MARK: - JmoVxia---类-属性
class CLCircleRetroTransitionController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    private lazy var bottomButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .init("#FF6666")
        view.setImage(UIImage(named: "add"), for: .normal)
        view.setImage(UIImage(named: "add"), for: .selected)
        view.setImage(UIImage(named: "add"), for: .highlighted)
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLCircleRetroTransitionController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.delegate = nil
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
//MARK: - JmoVxia---布局
private extension CLCircleRetroTransitionController {
    func initUI() {
        view.backgroundColor = .init("#FF9966")
        view.addSubview(bottomButton)
    }
    func makeConstraints() {
        bottomButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(60)
        }
    }
}
//MARK: - JmoVxia---override
extension CLCircleRetroTransitionController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return CLCircleRetroTransition()
        }
        return nil
    }
}
//MARK: - JmoVxia---objc
@objc private extension CLCircleRetroTransitionController {
    func buttonAction() {
        let controller = CLCircleRetroPushTransitionController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
