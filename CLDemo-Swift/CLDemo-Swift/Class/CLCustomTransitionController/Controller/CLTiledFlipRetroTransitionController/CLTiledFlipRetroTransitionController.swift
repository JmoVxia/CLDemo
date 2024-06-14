//
//  CLTiledFlipRetroTransitionController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/16.
//

import UIKit

// MARK: - JmoVxia---类-属性

class CLTiledFlipRetroTransitionController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "2")
        return view
    }()

    private lazy var bottomButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .init("#FF6666")
        view.setImage(UIImage(named: "addcc"), for: .normal)
        view.setImage(UIImage(named: "addcc"), for: .selected)
        view.setImage(UIImage(named: "addcc"), for: .highlighted)
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
}

// MARK: - JmoVxia---生命周期

extension CLTiledFlipRetroTransitionController {
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

// MARK: - JmoVxia---布局

private extension CLTiledFlipRetroTransitionController {
    func initUI() {
        view.addSubview(imageView)
        view.addSubview(bottomButton)
    }

    func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bottomButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-safeAreaEdgeInsets.bottom - 40)
            make.size.equalTo(60)
        }
    }
}

// MARK: - JmoVxia---override

extension CLTiledFlipRetroTransitionController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return CLTiledFlipRetroTransition()
        }
        return nil
    }
}

// MARK: - JmoVxia---objc

@objc private extension CLTiledFlipRetroTransitionController {
    func buttonAction() {
        let controller = CLTiledFlipRetroPushTransitionController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
