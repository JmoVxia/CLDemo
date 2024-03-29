//
//  CLPopupFoodPickerController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupFoodPickerController: CLPopoverController {
    var selectedCallback: ((String, String, String, String) -> Void)?
    lazy var topToolBar: UIButton = {
        let topToolBar = UIButton()
        topToolBar.backgroundColor = .init("#F8F6F9")
        return topToolBar
    }()

    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.titleLabel?.font = .mediumPingFangSC(14)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitle("取消", for: .selected)
        cancelButton.setTitle("取消", for: .highlighted)
        cancelButton.setTitleColor(.init("#666666"), for: .normal)
        cancelButton.setTitleColor(.init("#666666"), for: .selected)
        cancelButton.setTitleColor(.init("#666666"), for: .highlighted)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return cancelButton
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "选择饮食"
        view.font = .boldPingFangSC(16)
        view.textColor = .init("#666666")
        return view
    }()

    lazy var foodPicker: CLPopupFoodPickerView = {
        let view = CLPopupFoodPickerView(frame: CGRect(x: 0, y: 50, width: screenWidth, height: 302.5))
        view.backgroundColor = .white
        view.selectedCallback = { [weak self] value1, value2, value3, foodId in
            self?.selectedCallback?(value1, value2, value3, foodId)
            self?.dismissAnimation()
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        showAnimation()
    }
}

extension CLPopupFoodPickerController {
    func initUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.addSubview(topToolBar)
        topToolBar.addSubview(cancelButton)
        topToolBar.addSubview(titleLabel)
        view.addSubview(foodPicker)
    }
}

extension CLPopupFoodPickerController {
    func showAnimation() {
        topToolBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(view.snp.bottom)
        }
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.left.equalTo(view.safeAreaLayoutGuide).offset(15)
            } else {
                make.left.equalTo(15)
            }
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        foodPicker.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topToolBar.snp.bottom)
            make.height.equalTo(302.5)
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
        topToolBar.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(-50 - 302.5)
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func dismissAnimation() {
        topToolBar.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom)
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }) { _ in
            self.hidden()
        }
    }
}

extension CLPopupFoodPickerController {
    @objc func cancelAction() {
        dismissAnimation()
    }
}

extension CLPopupFoodPickerController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismissAnimation()
    }
}
