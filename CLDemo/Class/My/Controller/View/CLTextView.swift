//
//  CLTextView.swift
//  CLDemo
//
//  Created by AUG on 2019/3/28.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

class CLTextViewConfigure: NSObject {
    ///背景颜色
    var backgroundColor: UIColor = UIColor.white
    ///占位文字
    var placeholder: String = "请输入文字"
    ///占位文字颜色
    var placeholderTextColor: UIColor = UIColor.black
    ///text字体
    var textFont: UIFont = UIFont.systemFont(ofSize: 12)
    ///textView颜色
    var textColor: UIColor = UIColor.black
    ///光标颜色
    var cursorColor: UIColor = UIColor.blue
    ///计数label字体
    var lengthFont: UIFont = UIFont.systemFont(ofSize: 12)
    ///计数label字体颜色
    var lengthColor: UIColor = UIColor.black
    ///默认行数
    var defaultLine: NSInteger = 3
    ///最大行数
    var textViewMaxLine: NSInteger = 6
    ///最大字数
    var maxCount = INTMAX_MAX
    ///最大字节
    var maxBytesLength: NSInteger = 520
    ///输入框间距
    var edgeInsets: UIEdgeInsets = .zero
    ///键盘风格
    var keyboardAppearance: UIKeyboardAppearance = .light
    
    fileprivate class func defaultConfigure() -> CLTextViewConfigure {
        let configure = CLTextViewConfigure()
        return configure
    }
}

protocol CLTextViewDelegate: class {
    ///输入改变
    func textViewDidChange(textView:CLTextView) -> Void
    ///开始输入
    func textViewBeginEditing(textView:CLTextView) -> Void
    ///结束输入
    func textViewEndEditing(textView:CLTextView) -> Void
}
extension CLTextViewDelegate {
    ///输入改变
    func textViewDidChange(textView:CLTextView) -> Void {
        
    }
    ///开始输入
    func textViewBeginEditing(textView:CLTextView) -> Void {
        
    }
    ///结束输入
    func textViewEndEditing(textView:CLTextView) -> Void {
        
    }
}

class CLTextView: UIView {
    ///代理
    weak var delegate: CLTextViewDelegate?
    ///输入框
    private let textView: UITextView = UITextView()
    ///占位文字laebl
    private let placeholderLabel = UILabel()
    ///计数label
    private let lengthLabel: UILabel = UILabel()
    ///默认配置
    private let configure: CLTextViewConfigure = CLTextViewConfigure.defaultConfigure()
    ///输入的文字
    private (set) var text: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = configure.backgroundColor
        
        lengthLabel.font = configure.lengthFont
        lengthLabel.text = String.init(format: "0/%ld", configure.maxBytesLength)
        addSubview(lengthLabel)
        lengthLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.right.equalTo(-5)
        }
        
        textView.delegate = self
        textView.textColor = configure.textColor
        textView.tintColor = configure.cursorColor
        textView.keyboardAppearance = configure.keyboardAppearance
        textView.font = configure.textFont
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(defaultHeight())
            make.bottom.equalTo(lengthLabel.snp.top)
        }
        
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.textColor = configure.placeholderTextColor
        placeholderLabel.font = textView.font
        placeholderLabel.numberOfLines = 0
        placeholderLabel.text = configure.placeholder
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView)
            make.left.equalTo(textView).offset(4)
            make.right.lessThanOrEqualTo(textView.snp.right)
            make.bottom.lessThanOrEqualTo(textView.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///默认高度
    private func defaultHeight() -> CGFloat {
        let lineH: CGFloat = textView.font!.lineHeight
        let textViewHeight: CGFloat = ceil(lineH * CGFloat(configure.defaultLine))
        return textViewHeight
    }
    ///更新默认配置
    func updateWithConfigure(_ configureBlock: ((CLTextViewConfigure) -> Void)?) {
        configureBlock?(configure);
        
        backgroundColor = configure.backgroundColor
        
        textView.textColor = configure.textColor
        textView.font = configure.textFont
        textView.tintColor = configure.cursorColor
        textView.keyboardAppearance = configure.keyboardAppearance

        placeholderLabel.text = configure.placeholder
        placeholderLabel.textColor = configure.placeholderTextColor
        placeholderLabel.font = textView.font
        
        lengthLabel.font = configure.lengthFont
        lengthLabel.textColor = configure.lengthColor
        
        textView.snp.remakeConstraints { (make) in
            make.left.equalTo(configure.edgeInsets.left).priority(.low)
            make.right.equalTo(configure.edgeInsets.right).priority(.low)
            make.top.equalTo(configure.edgeInsets.top).priority(.low)
            make.bottom.equalTo(lengthLabel.snp.top).offset(configure.edgeInsets.bottom).priority(.low)
            make.height.equalTo(defaultHeight())
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension CLTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.count > 0 ? true : false
        //输入状态不计算
        if let rang = textView.markedTextRange {
            if let _ = textView.position(from: rang.start, offset: 0) {
                return
            }
        }
        //是否变化
        var isChange: Bool = true
        //限制字数
        if textView.text.utf16.count > configure.maxCount {
            var range: NSRange
            var inputCount: NSInteger = 0
            var i = 0
            while i < textView.text.utf16.count && inputCount <= configure.maxCount {
                range = (textView.text as NSString).rangeOfComposedCharacterSequence(at: i)
                inputCount += (textView.text as NSString).substring(with: range).count
                if (inputCount > configure.maxCount) {
                    isChange = false
                    let newText = (textView.text as NSString).substring(with: NSRange.init(location: 0, length: range.location))
                    textView.text = newText
                }
                i += range.length
            }
        }
        //限制字节
        let textBytesLength: NSInteger = textView.text.bytesLength()
        if textBytesLength > configure.maxBytesLength {
            var range: NSRange
            var byteLength: NSInteger = 0
            var i = 0
            while i < textView.text.utf16.count && byteLength <= configure.maxBytesLength {
                range = (textView.text as NSString).rangeOfComposedCharacterSequence(at: i)
                byteLength += strlen((textView.text as NSString).substring(with: range))
                if (byteLength > configure.maxBytesLength) {
                    isChange = false
                    let newText = (textView.text as NSString).substring(with: NSRange.init(location: 0, length: range.location))
                    textView.text = newText
                }
                i += range.length
            }
        }
        
        text = textView.text
        
        let string = String.init(format: "%ld/%ld", textView.text.bytesLength(), configure.maxBytesLength)
        lengthLabel.text = string
        
        let contentSizeH: CGFloat = max(textView.contentSize.height, defaultHeight())
        let lineH: CGFloat = textView.font!.lineHeight
        let maxTextViewHeight: CGFloat = ceil(lineH * CGFloat(configure.textViewMaxLine))
        textView.snp.updateConstraints { (make) in
            make.height.equalTo(min(contentSizeH, maxTextViewHeight))
        }
        setNeedsLayout()
        layoutIfNeeded()
        textView.scrollRangeToVisible(NSRange(location: textView.selectedRange.location, length: 1))
        
        if  isChange {
            delegate?.textViewDidChange(textView: self)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewBeginEditing(textView: self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewEndEditing(textView: self)
    }
}

extension String {
    func bytesLength() -> NSInteger {
        return self.lengthOfBytes(using: .utf8)
    }
}
