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
    var pointRadius: CGFloat = 9 * 0.5
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
    
    class func defaultConfig() -> CLPasswordInputViewConfigure {
        let configure = CLPasswordInputViewConfigure()
        return configure
    }
}

protocol CLPasswordInputViewDelegate {
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

class CLPasswordInputView: UIView {
    
    var delete: CLPasswordInputViewDelegate?
    var config: CLPasswordInputViewConfigure
    
    private (set) var text: NSMutableString = NSMutableString()
    private var isShow: Bool = false
    
    override init(frame: CGRect) {
        config = CLPasswordInputViewConfigure.defaultConfig()
        super.init(frame: frame)
        backgroundColor = config.backgroundColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLPasswordInputView {
    override func becomeFirstResponder() -> Bool {
        if !isShow {
            delete?.passwordInputViewBeginInput(passwordInputView: self)
        }
        isShow = true;
        return super.becomeFirstResponder()
    }
    override func resignFirstResponder() -> Bool {
        if isShow {
            delete?.passwordInputViewEndInput(passwordInputView: self)
        }
        return super.resignFirstResponder()
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
    func updateWithConfig(config: ((CLPasswordInputViewConfigure) -> Void)?) -> Void {
        config?(self.config)
        backgroundColor = self.config.backgroundColor
        setNeedsDisplay()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        let height = rect.size.height
        let width = rect.size.width
        let squareWidth = max(min(height, config.squareWidth), config.pointRadius * 4)
        let middleSpace = CGFloat(width - CGFloat(config.passwordNum) * squareWidth) / CGFloat(CGFloat(config.passwordNum - 1) + config.spaceMultiple * 2)
        let leftSpace = middleSpace * config.spaceMultiple
        let y = (height - squareWidth) * 0.5
        
        let context = UIGraphicsGetCurrentContext()
        
        for i in 0 ..< config.passwordNum {
            context?.addRect(CGRect(x: leftSpace + CGFloat(i) * squareWidth + CGFloat(i) * middleSpace, y: y, width: squareWidth, height: squareWidth))
            context?.setLineWidth(1)
            context?.setStrokeColor(config.rectColor.cgColor)
            context?.setFillColor(config.rectBackgroundColor.cgColor)
        }
        context?.drawPath(using: .fillStroke)
        context?.setFillColor(config.pointColor.cgColor)
        
        for i in 0 ..< text.length {
            context?.addArc(center: CGPoint(x: leftSpace + CGFloat(i + 1) * squareWidth + CGFloat(i) * middleSpace - squareWidth * 0.5, y: y + squareWidth * 0.5), radius: config.pointRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            context?.drawPath(using: .fill)
        }
    }
}

extension CLPasswordInputView: UIKeyInput {
    var hasText: Bool {
        return text.length > 0
    }
    
    func insertText(_ text: String) {
        if self.text.length < config.passwordNum {
            let cs = NSCharacterSet.init(charactersIn: "0123456789").inverted
            let string = text.components(separatedBy: cs).joined(separator: "")
            let basicTest = text == string
            if basicTest {
                self.text.append(text)
                delete?.passwordInputViewDidChange(passwordInputView: self)
                if self.text.length == config.passwordNum {
                    delete?.passwordInputViewCompleteInput(passwordInputView: self)
                }
                setNeedsDisplay()
            }
        }
    }
    
    func deleteBackward() {
        if text.length > 0 {
            text.deleteCharacters(in: NSRange(location: text.length - 1, length: 1))
            delete?.passwordInputViewDidChange(passwordInputView: self)
        }
        delete?.passwordInputViewDidDeleteBackward(passwordInputView: self)
        setNeedsDisplay()
    }
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
