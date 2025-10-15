//
//  CLPopupDataRangPickerController.swift
//  CLDemo-Swift
//
//  Created by 菜鸽途讯 on 2025/10/15.
//

import UIKit

// MARK: - JmoVxia---类-属性

class CLPopupDataRangPickerController: CLPopoverController {
    private lazy var pickView: CLPopupDataRangPickerView = {
        let view = CLPopupDataRangPickerView()
        return view
    }()

    deinit {}
}

// MARK: - JmoVxia---生命周期

extension CLPopupDataRangPickerController {
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
}

// MARK: - JmoVxia---布局

private extension CLPopupDataRangPickerController {
    func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.addSubview(pickView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenAction))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    func makeConstraints() {
        pickView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLPopupDataRangPickerController {
    func configData() {}
}

// MARK: - JmoVxia---override

extension CLPopupDataRangPickerController {}

// MARK: - JmoVxia---objc

@objc private extension CLPopupDataRangPickerController {
    func hiddenAction() {
        dismissAnimation(completion: nil)
    }
}

// MARK: - JmoVxia---私有方法

private extension CLPopupDataRangPickerController {}

// MARK: - JmoVxia---公共方法

extension CLPopupDataRangPickerController {}

// MARK: - JmoVxia---CLPopoverProtocol

extension CLPopupDataRangPickerController: CLPopoverProtocol {
    func showAnimation(completion: (() -> Void)?) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        pickView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }

    func dismissAnimation(completion: (() -> Void)?) {
        pickView.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.left.right.equalToSuperview()
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }) { _ in
            CLPopoverManager.dismiss(self.key)
            completion?()
        }
    }
}

extension CLPopupDataRangPickerController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view, !(touchView is UIButton) else {
            return false
        }
        if pickView.bounds.contains(touch.location(in: pickView)) {
            return false
        }
        return true
    }
}
