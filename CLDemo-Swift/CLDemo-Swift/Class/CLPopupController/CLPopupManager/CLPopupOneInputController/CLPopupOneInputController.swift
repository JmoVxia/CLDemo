//
//  CLPopupOneInputController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

enum CLPopupOneInputType {
    ///呼吸频次
    case respiratoryFrequency
    ///尿量
    case UrineVolume
    ///心率
    case heartRate
    ///脉搏
    case pulse
}

class CLPopupOneInputController: CLPopupManagerController {
    var sureCallback: ((String?) -> ())?
    var type: CLPopupOneInputType = .respiratoryFrequency {
        didSet {
            switch type {
            case .respiratoryFrequency:
                titleLabel.text = "呼吸频次"
                textField.keyboardType = .numberPad
                textField.setPlaceholder("请输入每分钟呼吸次数", color: .hex("#999999"), font: UIFont.systemFont(ofSize: 16))
            case .UrineVolume:
                titleLabel.text = "尿量"
                textField.keyboardType = .decimalPad
                textField.setPlaceholder("请输入最近24小时尿量(ml)", color: .hex("#999999"), font: UIFont.systemFont(ofSize: 16))
            case .heartRate:
                titleLabel.text = "心率"
                textField.keyboardType = .numberPad
                textField.setPlaceholder("请输入每分钟心跳次数", color: .hex("#999999"), font: UIFont.systemFont(ofSize: 16))
            case .pulse:
                titleLabel.text = "脉搏"
                textField.keyboardType = .numberPad
                textField.setPlaceholder("请输入每分钟脉搏次数", color: .hex("#999999"), font: UIFont.systemFont(ofSize: 16))
            }
        }
    }
    private var isMoveUp: Bool = false
    private var isDismiss: Bool = false
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        return contentView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .themeColor
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textAlignment = .center
        return textField
    }()
    private lazy var fristLineView: UIView = {
        let fristLineView = UIView()
        fristLineView.backgroundColor = .hex("#F0F0F0")
        return fristLineView
    }()
    private lazy var fristTapView: UIControl = {
        let fristTapView = UIControl()
        fristTapView.addTarget(self, action: #selector(fristTapViewAction), for: .touchUpInside)
        return fristTapView
    }()
    private lazy var sureButton: UIButton = {
        let sureButton = UIButton()
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitle("确定", for: .selected)
        sureButton.setTitle("确定", for: .highlighted)
        sureButton.setTitleColor(.white, for: .normal)
        sureButton.setTitleColor(.white, for: .selected)
        sureButton.setTitleColor(.white, for: .highlighted)
        sureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sureButton.backgroundColor = .themeColor
        sureButton.layer.cornerRadius = 20
        sureButton.clipsToBounds = true
        sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        return sureButton
    }()
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "clear"), for: .normal)
        closeButton.setImage(UIImage(named: "clear"), for: .selected)
        closeButton.setImage(UIImage(named: "clear"), for: .highlighted)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return closeButton
    }()
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension CLPopupOneInputController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        showAnimation()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
extension CLPopupOneInputController {
    private func initUI() {
        view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.00)
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(fristLineView)
        contentView.addSubview(fristTapView)
        contentView.addSubview(sureButton)
        view.addSubview(closeButton)
    }
    private func makeConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.bottom.equalTo(view.snp.top)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(36)
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        fristLineView.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(16)
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.height.equalTo(0.5)
        }
        fristTapView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(fristLineView)
        }
        sureButton.snp.makeConstraints { (make) in
            make.left.equalTo(70)
            make.right.equalTo(-70)
            make.height.equalTo(40)
            make.bottom.equalTo(-32)
            make.top.equalTo(fristLineView.snp.bottom).offset(20)
        }
        closeButton.snp.makeConstraints { (make) in
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top).offset(-15)
        }
    }
}
extension CLPopupOneInputController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
}
extension CLPopupOneInputController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else {
            return true
        }
        let text = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        if (string == "") {
            return true
        }
        switch type {
        case .respiratoryFrequency:
            return text.isValidPureNumbers()
        case .UrineVolume:
            return text.isValidDecimalPointCount(2)
        case .heartRate:
            return text.isValidPureNumbers()
        case .pulse:
            return text.isValidPureNumbers()
        }
    }
}
extension CLPopupOneInputController {
    // 键盘显示
    @objc func keyboardWillShow(notification: Notification) {
        DispatchQueue.main.async {
            guard let userInfo = notification.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval, let options = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSInteger else {return}
            let margin = keyboardRect.minY - 10
            self.isMoveUp = self.contentView.frame.maxY - keyboardRect.minY > 0
            if self.isMoveUp {
                self.contentView.snp.remakeConstraints { (make) in
                    make.left.equalTo(36)
                    make.right.equalTo(-36)
                    make.bottom.equalTo(self.view.snp.top).offset(margin)
                }
                UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(options)), animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    // 键盘隐藏
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval, let options = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSInteger else {return}
        if !isDismiss, isMoveUp {
            DispatchQueue.main.async {
                self.contentView.snp.remakeConstraints { (make) in
                    make.left.equalTo(36)
                    make.right.equalTo(-36)
                    make.center.equalToSuperview()
                }
                UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(options)), animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}
extension CLPopupOneInputController {
    @objc func fristTapViewAction() {
        DispatchQueue.main.async {
            self.textField.becomeFirstResponder()
        }
    }
    @objc func sureAction() {
        isDismiss = true
        sureCallback?(textField.text)
        closeAction()
    }
    @objc func closeAction() {
        isDismiss = true
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        dismissAnimation { (_) in
            
            CLPopupManager.dismiss(self.configure.identifier)
        }
    }
}
extension CLPopupOneInputController {
    private func showAnimation() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        contentView.snp.remakeConstraints { (make) in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.center.equalToSuperview()
        }
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.40)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    private func dismissAnimation(completion: ((Bool) -> Void)? = nil) {
        contentView.snp.remakeConstraints { (make) in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.bottom.equalTo(view.snp.top)
        }
        UIView.animate(withDuration: 0.35, animations: {
            self.view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.00)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
}
