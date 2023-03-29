//
//  CLPasswordInputView.swift
//  CLDemo
//
//  Created by AUG on 2019/2/1.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit

class CLPasswordInputViewConfig: NSObject {
    /// 密码的位数
    var passwordLength = 6
    /// 边框正方形的大小
    var squareSize = 45.0
    /// 边框圆角
    var cornerRadius = 5.0
    /// 边距相对中间间隙倍数
    var spaceRatio = 2.0
    /// 线条宽度
    var lineWidth = 5.0
    /// 圆点大小
    var dotRadius = 0.0
    /// 黑点颜色
    var dotColor = UIColor.black
    /// 边框颜色
    var borderColor = UIColor.lightGray
    /// 输入框背景颜色
    var inputBackgroundColor = UIColor.white
    /// 控件背景颜色
    var backgroundColor = UIColor.white
    /// 键盘类型
    var keyboardType = UIKeyboardType.asciiCapable
    /// 文字属性
    var attributes: [NSAttributedString.Key: Any]?
    /// 输入限制正则
    var regex = "^[a-zA-Z0-9]*$"
    /// 是否转化为全大写
    var shouldConvertToUpper = true
    /// 是否支持三方键盘
    var thirdPartyKeyboardEnabled = false

    fileprivate class func config() -> CLPasswordInputViewConfig {
        return CLPasswordInputViewConfig()
    }
}

protocol CLPasswordInputViewDelegate: AnyObject {
    /// 输入改变
    func passwordInputViewDidChange(passwordInputView: CLPasswordInputView) -> Void
    /// 点击删除
    func passwordInputViewDidDeleteBackward(passwordInputView: CLPasswordInputView) -> Void
    /// 输入完成
    func passwordInputViewCompleteInput(passwordInputView: CLPasswordInputView) -> Void
    /// 开始输入
    func passwordInputViewBeginInput(passwordInputView: CLPasswordInputView) -> Void
    /// 结束输入
    func passwordInputViewEndInput(passwordInputView: CLPasswordInputView) -> Void
}

extension CLPasswordInputViewDelegate {
    /// 输入改变
    func passwordInputViewDidChange(passwordInputView: CLPasswordInputView) {}

    /// 点击删除
    func passwordInputViewDidDeleteBackward(passwordInputView: CLPasswordInputView) {}

    /// 输入完成
    func passwordInputViewCompleteInput(passwordInputView: CLPasswordInputView) {}

    /// 开始输入
    func passwordInputViewBeginInput(passwordInputView: CLPasswordInputView) {}

    /// 结束输入
    func passwordInputViewEndInput(passwordInputView: CLPasswordInputView) {}
}

class CLPasswordInputView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = config.backgroundColor
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: CLPasswordInputViewDelegate?

    private(set) var config = CLPasswordInputViewConfig.config()

    private(set) var text = String()

    private(set) var isShowKeyboard = false
}

extension CLPasswordInputView {
    override func becomeFirstResponder() -> Bool {
        if !isShowKeyboard {
            delegate?.passwordInputViewBeginInput(passwordInputView: self)
        }
        isShowKeyboard = true
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        if isShowKeyboard {
            delegate?.passwordInputViewEndInput(passwordInputView: self)
        }
        isShowKeyboard = false
        return super.resignFirstResponder()
    }

    override var canBecomeFirstResponder: Bool {
        true
    }

    override var canResignFirstResponder: Bool {
        true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard !isFirstResponder else { return }
        _ = becomeFirstResponder()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let height = rect.size.height
        let width = rect.size.width
        let squareWidth = min(max(min(height, config.squareSize), config.dotRadius * 4), height)
        let middleSpace = CGFloat(width - CGFloat(config.passwordLength) * squareWidth) / CGFloat(CGFloat(config.passwordLength - 1) + config.spaceRatio * 2)
        let leftSpace = middleSpace * config.spaceRatio
        let y = (height - squareWidth) * 0.5

        let rectPaths = (0 ..< config.passwordLength).map { i in
            UIBezierPath(roundedRect: CGRect(x: leftSpace + CGFloat(i) * squareWidth + CGFloat(i) * middleSpace, y: y, width: squareWidth, height: squareWidth), cornerRadius: config.cornerRadius).cgPath
        }
        context.addPath(rectPaths.reduce(CGMutablePath()) { $0.addPath($1); return $0 })
        context.setLineWidth(config.lineWidth)
        context.setStrokeColor(config.borderColor.cgColor)
        context.setFillColor(config.inputBackgroundColor.cgColor)
        context.drawPath(using: .fillStroke)

        let dotPaths = text.enumerated().map { i, char -> CGPath in
            if config.dotRadius > .zero {
                return UIBezierPath(arcCenter: CGPoint(x: leftSpace + CGFloat(i + 1) * squareWidth + CGFloat(i) * middleSpace - squareWidth * 0.5, y: y + squareWidth * 0.5), radius: config.dotRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
            } else {
                let string = String(char) as NSString
                let size = string.size(withAttributes: config.attributes)
                string.draw(at: CGPoint(x: leftSpace + CGFloat(i + 1) * squareWidth + CGFloat(i) * middleSpace - squareWidth * 0.5 - size.width * 0.5, y: y + squareWidth * 0.5 - size.height * 0.5), withAttributes: config.attributes)
                return CGMutablePath()
            }
        }
        context.addPath(dotPaths.reduce(CGMutablePath()) { $0.addPath($1); return $0 })
        context.setFillColor(config.dotColor.cgColor)
        context.drawPath(using: .fill)
    }
}

extension CLPasswordInputView {
    func updateConfig(_ configBlock: ((CLPasswordInputViewConfig) -> Void)?) {
        configBlock?(config)
        backgroundColor = config.backgroundColor
        setNeedsDisplay()
    }
}

extension CLPasswordInputView: UIKeyInput {
    var hasText: Bool {
        !text.isEmpty
    }

    func insertText(_ text: String) {
        guard text.range(of: config.regex, options: .regularExpression) != nil else { return }
        guard self.text.count < config.passwordLength else { return }

        let text = config.shouldConvertToUpper ? text.uppercased() : text
        self.text.append(text)
        setNeedsDisplay()

        delegate?.passwordInputViewDidChange(passwordInputView: self)
        guard self.text.count == config.passwordLength else { return }
        delegate?.passwordInputViewCompleteInput(passwordInputView: self)
    }

    func deleteBackward() {
        guard !text.isEmpty else { return }
        text.removeLast()
        delegate?.passwordInputViewDidChange(passwordInputView: self)
        delegate?.passwordInputViewDidDeleteBackward(passwordInputView: self)
        setNeedsDisplay()
    }

    var keyboardType: UIKeyboardType {
        get {
            return config.keyboardType
        }
        set {}
    }

    var isSecureTextEntry: Bool {
        get {
            return !config.thirdPartyKeyboardEnabled
        }
        set {}
    }
}
