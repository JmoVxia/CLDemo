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
    var squareWidth: Float = 50
    ///黑点的半径
    var pointRadius: Float = 9 * 0.5
    ///边距相对中间间隙倍数
    var spaceMultiple: Float = 5;
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
    var keyboardType: UIKeyboardType {
        return .numberPad
    }
    override var canBecomeFocused: Bool {
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
        
//        CGFloat height = rect.size.height;
//        CGFloat width = rect.size.width;
//        CGFloat squareWidth = MAX(MIN(height, self.configure.squareWidth), (self.configure.pointRadius * 4));
//        CGFloat middleSpace = (width - self.configure.passwordNum * squareWidth) / (self.configure.passwordNum - 1 + self.configure.spaceMultiple * 2);
//        CGFloat leftSpace = middleSpace * self.configure.spaceMultiple;
//        CGFloat y = (height - squareWidth) * 0.5;
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        //画外框
//        for (NSUInteger i = 0; i < self.configure.passwordNum; i++) {
//            CGContextAddRect(context, CGRectMake(leftSpace + i * squareWidth + i * middleSpace, y, squareWidth, squareWidth));
//            CGContextSetLineWidth(context, 1);
//            CGContextSetStrokeColorWithColor(context, self.configure.rectColor.CGColor);
//            CGContextSetFillColorWithColor(context, self.configure.rectBackgroundColor.CGColor);
//        }
//        CGContextDrawPath(context, kCGPathFillStroke);
//        CGContextSetFillColorWithColor(context, self.configure.pointColor.CGColor);
//        //画黑点
//        for (NSUInteger i = 1; i <= self.text.length; i++) {
//            CGContextAddArc(context,  leftSpace + i * squareWidth + (i - 1) * middleSpace - squareWidth * 0.5, y + squareWidth * 0.5, self.configure.pointRadius, 0, M_PI * 2, YES);
//            CGContextDrawPath(context, kCGPathFill);
//        }
    }
}

extension CLPasswordInputView: UIKeyInput {
    var hasText: Bool {
        return text.length > 0
    }
    
    func insertText(_ text: String) {
        if self.text.length < config.passwordNum {
            let cs = NSCharacterSet.init(charactersIn: "123456789").inverted
            let string = text.components(separatedBy: cs).joined(separator: "")
            let basicTest = text == string
            if basicTest {
                self.text.components(separatedBy: text)
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
            text.deleteCharacters(in: NSRange(location: text.length, length: 1))
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
