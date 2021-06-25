//
//  CLPopupBMIInputController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/8.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupBMIInputController: CLPopupManagerController {
    var bmiCallback: ((CGFloat) -> ())?
    private var bmiValue: CGFloat = 0.0
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
        titleLabel.text = "BMI"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .themeColor
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private lazy var fristTextField: UITextField = {
        let fristTextField = UITextField()
        fristTextField.keyboardType = .decimalPad
        fristTextField.delegate = self
        fristTextField.setPlaceholder("请输入体重(kg)", color: .hex("#999999"), font: UIFont.systemFont(ofSize: 16))
        fristTextField.textAlignment = .center
        return fristTextField
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
    private lazy var secondTextField: UITextField = {
        let secondTextField = UITextField()
        secondTextField.keyboardType = .decimalPad
        secondTextField.delegate = self
        secondTextField.setPlaceholder("请输入身高(cm)", color: .hex("#999999"), font: UIFont.systemFont(ofSize: 16))
        secondTextField.textAlignment = .center
        return secondTextField
    }()
    private lazy var secondLineView: UIView = {
        let secondLineView = UIView()
        secondLineView.backgroundColor = .hex("#F0F0F0")
        return secondLineView
    }()
    private lazy var secondTapView: UIControl = {
        let secondTapView = UIControl()
        secondTapView.addTarget(self, action: #selector(secondTapViewAction), for: .touchUpInside)
        return secondTapView
    }()
    private lazy var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.text = "您的BMI：--"
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont.systemFont(ofSize: 16)
        subTitleLabel.textColor = UIColor.hex("#666666")
        subTitleLabel.numberOfLines = 0
        return subTitleLabel
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
extension CLPopupBMIInputController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        showAnimation()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
extension CLPopupBMIInputController {
    private func initUI() {
        view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.00)
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(fristTextField)
        contentView.addSubview(fristLineView)
        contentView.addSubview(fristTapView)
        contentView.addSubview(secondTextField)
        contentView.addSubview(secondLineView)
        contentView.addSubview(secondTapView)
        contentView.addSubview(subTitleLabel)
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
        fristTextField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        fristLineView.snp.makeConstraints { (make) in
            make.top.equalTo(fristTextField.snp.bottom).offset(16)
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.height.equalTo(0.5)
        }
        fristTapView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(fristLineView)
        }
        secondTextField.snp.makeConstraints { (make) in
            make.top.equalTo(fristLineView.snp.bottom).offset(36)
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        secondLineView.snp.makeConstraints { (make) in
            make.top.equalTo(secondTextField.snp.bottom).offset(16)
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.height.equalTo(0.5)
        }
        secondTapView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(fristLineView.snp.bottom)
            make.bottom.equalTo(secondLineView)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondLineView.snp.bottom).offset(22)
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        sureButton.snp.makeConstraints { (make) in
            make.left.equalTo(70)
            make.right.equalTo(-70)
            make.height.equalTo(40)
            make.bottom.equalTo(-32)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(12)
        }
        closeButton.snp.makeConstraints { (make) in
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top).offset(-15)
        }
    }
}
extension CLPopupBMIInputController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
}
extension CLPopupBMIInputController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else {
            return true
        }
        let text = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        if (string == "") {
            return true
        }
        return text.isValidDecimalPointCount(2)
    }
}
extension CLPopupBMIInputController {
    @objc func textDidChange(notification: Notification) {
        let textField = notification.object as? UITextField
        if textField == fristTextField {
            calculateBMI()
        }else if textField == secondTextField {
            calculateBMI()
        }
    }
}
extension CLPopupBMIInputController {
    func calculateBMI() {
        guard let fristText = fristTextField.text, let secondText = secondTextField.text else {
            return
        }
        let weight = NSDecimalNumber(string: fristText)
        let height = NSDecimalNumber(string: secondText)
        var bmi: String = "--"
        if height.doubleValue > 0.0 , weight.doubleValue > 0.0 {
            let plain = NSDecimalNumberHandler(roundingMode: .plain, scale: 1, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
            let bmiDecimalNumber = weight.dividing(by: height.multiplying(by: height)).multiplying(by: NSDecimalNumber(string: "10000"), withBehavior: plain)
            bmi = bmiDecimalNumber.stringValue
            bmiValue = CGFloat(bmiDecimalNumber.floatValue)
        }else {
            bmiValue = 0.0
        }
        subTitleLabel.text = "您的BMI：\(bmi)"
    }
}
extension CLPopupBMIInputController {
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
extension CLPopupBMIInputController {
    @objc func fristTapViewAction() {
        DispatchQueue.main.async {
            self.fristTextField.becomeFirstResponder()
        }
    }
    @objc func secondTapViewAction() {
        DispatchQueue.main.async {
            self.secondTextField.becomeFirstResponder()
        }
    }
    @objc func sureAction() {
        isDismiss = true
        bmiCallback?(bmiValue)
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
extension CLPopupBMIInputController {
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
