//
//  CLBubbleTransitionController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/16.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---枚举
extension CLBubbleTransitionController {
}
//MARK: - JmoVxia---类-属性
class CLBubbleTransitionController: CLController {
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
        view.backgroundColor = .hex("#FF6666")
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
extension CLBubbleTransitionController {
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
private extension CLBubbleTransitionController {
    func initUI() {
        view.addSubview(bottomButton)
    }
    func makeConstraints() {
        bottomButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-safeAreaEdgeInsets.bottom - 40)
            make.size.equalTo(60)
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLBubbleTransitionController {
    func initData() {
    }
}
//MARK: - JmoVxia---override
extension CLBubbleTransitionController {
}
//MARK: - JmoVxia---objc
@objc private extension CLBubbleTransitionController {
    func buttonAction() {
        let controller = CLBubbleTransitionPresentController()
        controller.startCenter = self.bottomButton.center
        present(controller, animated: true)
    }
}
//MARK: - JmoVxia---私有方法
private extension CLBubbleTransitionController {
}
//MARK: - JmoVxia---公共方法
extension CLBubbleTransitionController {
}
