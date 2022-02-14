//
//  CLIngredientSearchView.swift
//  CL
//
//  Created by Chen JmoVxia on 2021/11/15.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---枚举

extension CLIngredientSearchView {}

// MARK: - JmoVxia---类-属性

class CLIngredientSearchView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {}

    private lazy var contentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 18
        view.backgroundColor = .init("#F4F4F4")
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "searchIcon")
        return view
    }()

    lazy var searchTextField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.tintColor = .theme
        view.returnKeyType = .search
        view.enablesReturnKeyAutomatically = true
        view.setPlaceholder("请输入关键字", color: .init("#D4D4D4"), font: PingFangSCMedium(14))
        view.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        return view
    }()

    private lazy var clearButton: UIButton = {
        let view = UIButton()
        view.isHidden = true
        view.setImage(UIImage(named: "clearIcon"), for: .normal)
        view.setImage(UIImage(named: "clearIcon"), for: .selected)
        view.setImage(UIImage(named: "clearIcon"), for: .highlighted)
        view.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.alpha = 0.0
        view.titleLabel?.font = PingFangSCMedium(14)
        view.setTitle("取消", for: .normal)
        view.setTitle("取消", for: .selected)
        view.setTitle("取消", for: .highlighted)
        view.setTitleColor(.init("333333"), for: .normal)
        view.setTitleColor(.init("333333"), for: .selected)
        view.setTitleColor(.init("333333"), for: .highlighted)
        view.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()

    var shouldBeginEditingCallback: (() -> Void)?
    var didEndEditingCallback: (() -> Void)?
    var textChangeCallback: ((String?) -> Void)?
    var clearCallback: (() -> Void)?
    var text: String? {
        return searchTextField.text
    }
}

// MARK: - JmoVxia---布局

private extension CLIngredientSearchView {
    func initUI() {
        clipsToBounds = true
        addSubview(contentView)
        addSubview(cancelButton)
        contentView.addSubview(searchTextField)
        contentView.addSubview(iconImageView)
        contentView.addSubview(clearButton)
    }

    func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(cancelButton.snp.left).offset(-7)
        }
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.snp.right).offset(7)
        }
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
            make.left.equalTo(13)
        }
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(5)
            make.right.equalTo(clearButton.snp.left).offset(5)
            make.centerY.height.equalToSuperview()
        }
        clearButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
            make.right.equalTo(-13)
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLIngredientSearchView {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLIngredientSearchView {
    override var canBecomeFirstResponder: Bool {
        return searchTextField.canBecomeFirstResponder
    }

    override var canResignFirstResponder: Bool {
        return searchTextField.canResignFirstResponder
    }
}

// MARK: - JmoVxia---objc

@objc private extension CLIngredientSearchView {
    func textDidChange(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.textChangeCallback?(textField.text)
            self.clearButton.isHidden = textField.text?.isEmpty ?? true
        }
    }

    func clearText() {
        clearButton.isHidden = true
        searchTextField.text = nil
        textChangeCallback?(nil)
        searchTextField.becomeFirstResponder()
    }

    func cancelAction() {
        clearText()
        endEditing(true)
    }
}

// MARK: - JmoVxia---私有方法

private extension CLIngredientSearchView {
    func showCancelAnimation() {
        cancelButton.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25) {
            self.cancelButton.alpha = 1.0
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }

    func hiddenCancelAnimation() {
        cancelButton.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.snp.right).offset(7)
        }
        UIView.animate(withDuration: 0.25) {
            self.cancelButton.alpha = 0.0
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}

// MARK: - JmoVxia---公共方法

extension CLIngredientSearchView {
    func setText(_ text: String) {
        guard text != self.text else { return }
        searchTextField.text = text
        clearButton.isHidden = text.isEmpty
        textChangeCallback?(text)
    }

    func cancel() {
        cancelAction()
    }
}

// MARK: - JmoVxia---UITextFieldDelegate

extension CLIngredientSearchView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        showCancelAnimation()
        shouldBeginEditingCallback?()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            hiddenCancelAnimation()
        }
        didEndEditingCallback?()
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
