//
//  CLBubbleTransitionPresentController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/14.
//

import UIKit

// MARK: - JmoVxia---类-属性

class CLBubbleTransitionPresentController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = bubbleDelegate
        modalPresentationStyle = .custom
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

    var startCenter: CGPoint = .zero
    private lazy var bottomButton: UIButton = {
        let view = UIButton()
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        view.backgroundColor = .orange.withAlphaComponent(0.5)
        view.setImage(UIImage(named: "addcc"), for: .normal)
        view.setImage(UIImage(named: "addcc"), for: .selected)
        view.setImage(UIImage(named: "addcc"), for: .highlighted)
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()

    lazy var bubbleDelegate: CLBubbleTransitionDelegate = {
        let delegate = CLBubbleTransitionDelegate { [weak self] in
            guard let self else { return (.zero, .white) }
            return (startCenter, .init("#FF6666"))
        } endCallback: { [weak self] in
            guard let self else { return (.zero, .white) }
            return (bottomButton.center, .init("#FF6666"))
        }
        delegate.interactiveTransition.attach(to: self)
        return delegate
    }()
}

// MARK: - JmoVxia---生命周期

extension CLBubbleTransitionPresentController {
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

// MARK: - JmoVxia---布局

private extension CLBubbleTransitionPresentController {
    func initUI() {
        transitioningDelegate = bubbleDelegate
        view.backgroundColor = .init("#FF6666")
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

// MARK: - JmoVxia---数据

private extension CLBubbleTransitionPresentController {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLBubbleTransitionPresentController {}

// MARK: - JmoVxia---objc

@objc private extension CLBubbleTransitionPresentController {
    func buttonAction() {
        dismiss(animated: true)
        bubbleDelegate.interactiveTransition.finish()
    }
}

// MARK: - JmoVxia---私有方法

private extension CLBubbleTransitionPresentController {}

// MARK: - JmoVxia---公共方法

extension CLBubbleTransitionPresentController {}
