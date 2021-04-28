//
//  CLPasswordInputView.swift
//  CLDemo
//
//  Created by AUG on 2019/2/1.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit

class CLPasswordInputViewConfigure: NSObject {
    ///密码的位数
    var passwordNum: UInt = 6
    ///边框正方形的大小
    var squareWidth: CGFloat = 50
    ///黑点的半径
    var pointRadius: CGFloat = 18 * 0.5
    ///边距相对中间间隙倍数
    var spaceMultiple: CGFloat = 5;
    ///黑点颜色
    var pointColor: UIColor = UIColor.black
    ///边框颜色
    var rectColor: UIColor = UIColor.lightGray
    ///输入框背景颜色
    var rectBackgroundColor: UIColor = UIColor.white
    ///控件背景颜色
    var backgroundColor: UIColor = UIColor.white
    ///是否支持三方键盘
    var threePartyKeyboard: Bool = false
    
    fileprivate class func defaultConfigure() -> CLPasswordInputViewConfigure {
        let configure = CLPasswordInputViewConfigure()
        return configure
    }
}

protocol CLPasswordInputViewDelegate: AnyObject {
    ///输入改变
    func passwordInputViewDidChange(passwordInputView:CLPasswordInputView) -> Void
    ///点击删除
    func passwordInputViewDidDeleteBackward(passwordInputView:CLPasswordInputView) -> Void
    ///输入完成
    func passwordInputViewCompleteInput(passwordInputView:CLPasswordInputView) -> Void
    ///开始输入
    func passwordInputViewBeginInput(passwordInputView:CLPasswordInputView) -> Void
    ///结束输入
    func passwordInputViewEndInput(passwordInputView:CLPasswordInputView) -> Void
}

extension CLPasswordInputViewDelegate {
    ///输入改变
    func passwordInputViewDidChange(passwordInputView:CLPasswordInputView) -> Void {
        
    }
    ///点击删除
    func passwordInputViewDidDeleteBackward(passwordInputView:CLPasswordInputView) -> Void {
        
    }
    ///输入完成
    func passwordInputViewCompleteInput(passwordInputView:CLPasswordInputView) -> Void {
        
    }
    ///开始输入
    func passwordInputViewBeginInput(passwordInputView:CLPasswordInputView) -> Void {
        
    }
    ///结束输入
    func passwordInputViewEndInput(passwordInputView:CLPasswordInputView) -> Void {
        
    }
}

class CLPasswordInputView: UIView {
    
    weak var delegate: CLPasswordInputViewDelegate?
    var configure: CLPasswordInputViewConfigure
    
    private (set) var text: NSMutableString = NSMutableString()
    private var isShow: Bool = false
    
    override init(frame: CGRect) {
        configure = CLPasswordInputViewConfigure.defaultConfigure()
        super.init(frame: frame)
        backgroundColor = configure.backgroundColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLPasswordInputView {
    override func becomeFirstResponder() -> Bool {
        if !isShow {
            delegate?.passwordInputViewBeginInput(passwordInputView: self)
        }
        isShow = true;
        return super.becomeFirstResponder()
    }
    override func resignFirstResponder() -> Bool {
        if isShow {
            delegate?.passwordInputViewEndInput(passwordInputView: self)
        }
        isShow = false
        return super.resignFirstResponder()
    }
    var keyboardType: UIKeyboardType {
        get {
            return .numberPad
        }
        set {

        }
    }
    var isSecureTextEntry: Bool {
        get {
            return !configure.threePartyKeyboard
        }
        set {
            
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override var canResignFirstResponder: Bool {
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !isFirstResponder {
            _ = becomeFirstResponder()
        }
    }
    ///更新配置，block不会造成循环引用
    func updateWithConfigure(_ configureBlock: ((CLPasswordInputViewConfigure) -> Void)?) -> Void {
        configureBlock?(configure)
        backgroundColor = configure.backgroundColor
        setNeedsDisplay()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        let height = rect.size.height
        let width = rect.size.width
        let squareWidth = min(max(min(height, configure.squareWidth), configure.pointRadius * 4), height)
        let pointRadius = min(configure.pointRadius, squareWidth * 0.5) * 0.8
        let middleSpace = CGFloat(width - CGFloat(configure.passwordNum) * squareWidth) / CGFloat(CGFloat(configure.passwordNum - 1) + configure.spaceMultiple * 2)
        let leftSpace = middleSpace * configure.spaceMultiple
        let y = (height - squareWidth) * 0.5
        
        let context = UIGraphicsGetCurrentContext()
        
        for i in 0 ..< configure.passwordNum {
            context?.addRect(CGRect(x: leftSpace + CGFloat(i) * squareWidth + CGFloat(i) * middleSpace, y: y, width: squareWidth, height: squareWidth))
            context?.setLineWidth(1)
            context?.setStrokeColor(configure.rectColor.cgColor)
            context?.setFillColor(configure.rectBackgroundColor.cgColor)
        }
        context?.drawPath(using: .fillStroke)
        context?.setFillColor(configure.pointColor.cgColor)
        
        for i in 0 ..< text.length {
            context?.addArc(center: CGPoint(x: leftSpace + CGFloat(i + 1) * squareWidth + CGFloat(i) * middleSpace - squareWidth * 0.5, y: y + squareWidth * 0.5), radius: pointRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            context?.drawPath(using: .fill)
        }
    }
}

extension CLPasswordInputView: UIKeyInput {
    var hasText: Bool {
        return text.length > 0
    }
    
    func insertText(_ text: String) {
        if self.text.length < configure.passwordNum {
            let cs = NSCharacterSet.init(charactersIn: "0123456789").inverted
            let string = text.components(separatedBy: cs).joined(separator: "")
            let basicTest = text == string
            if basicTest {
                self.text.append(text)
                delegate?.passwordInputViewDidChange(passwordInputView: self)
                if self.text.length == configure.passwordNum {
                    delegate?.passwordInputViewCompleteInput(passwordInputView: self)
                }
                setNeedsDisplay()
            }
        }
    }
    
    func deleteBackward() {
        if text.length > 0 {
            text.deleteCharacters(in: NSRange(location: text.length - 1, length: 1))
            delegate?.passwordInputViewDidChange(passwordInputView: self)
        }
        delegate?.passwordInputViewDidDeleteBackward(passwordInputView: self)
        setNeedsDisplay()
    }
}

