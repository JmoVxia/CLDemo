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
    ///占位文字
    var placeholder: String = "AAAAAA"
    ///默认行数
    var defaultLine: NSInteger = 2
    ///最大行数
    var textViewMaxLine: NSInteger = 3
    ///最大字数
    var maxCount = 999999
    ///最大字节
    var maxBytesLength: NSInteger = 520
    ///输入框间距
    var edgeInsets: UIEdgeInsets = .zero
    
    fileprivate class func defaultConfigure() -> CLTextViewConfigure {
        let configure = CLTextViewConfigure()
        return configure
    }
}

class CLTextView: UIView {
    ///输入框
    private let textView: UITextView = UITextView()
    ///占位文字laebl
    private let placeholderLabel = UILabel()
    ///计数label
    private let lengthLabel: UILabel = UILabel()
    ///默认配置
    private let configure: CLTextViewConfigure = CLTextViewConfigure.defaultConfigure()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lengthLabel.backgroundColor = UIColor.orange
        lengthLabel.text = String.init(format: "0/%ld", configure.maxBytesLength)
        addSubview(lengthLabel)
        lengthLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.right.equalTo(-5)
        }
        
        textView.delegate = self
        textView.backgroundColor = UIColor.red
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(defaultHeight())
            make.bottom.equalTo(lengthLabel.snp.top)
        }
        
        placeholderLabel.backgroundColor = UIColor.clear
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
    func updateWithConfigure(_ configure: ((CLTextViewConfigure) -> Void)?) {
        configure?(self.configure);
        textView.snp.updateConstraints { (make) in
            make.left.equalTo(self.configure.edgeInsets.left)
            make.right.equalTo(self.configure.edgeInsets.right)
            make.top.equalTo(self.configure.edgeInsets.top)
            make.bottom.equalTo(lengthLabel.snp.top).offset(self.configure.edgeInsets.bottom)
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
        //限制字数
        if textView.text.utf16.count > configure.maxCount {
            var range: NSRange
            var inputCount: NSInteger = 0
            var i = 0
            while i < textView.text.utf16.count && inputCount <= configure.maxCount {
                range = (textView.text as NSString).rangeOfComposedCharacterSequence(at: i)
                inputCount += (textView.text as NSString).substring(with: range).count
                if (inputCount > configure.maxCount) {
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
                    let newText = (textView.text as NSString).substring(with: NSRange.init(location: 0, length: range.location))
                    textView.text = newText
                }
                i += range.length
            }
        }
        
        let string = String.init(format: "%ld/%ld", textView.text.bytesLength(), configure.maxBytesLength)
        lengthLabel.text = string

        let contentSizeH: CGFloat = max(textView.contentSize.height, defaultHeight())
        let lineH: CGFloat = textView.font!.lineHeight
        let maxTextViewHeight: CGFloat = ceil(lineH * CGFloat(configure.textViewMaxLine))
        print(contentSizeH)
            textView.snp.updateConstraints { (make) in
                make.height.equalTo(min(contentSizeH, maxTextViewHeight))
            }
        setNeedsLayout()
        layoutIfNeeded()
        textView.scrollRangeToVisible(NSRange(location: textView.selectedRange.location, length: 1))
    }
}

extension String {
    func bytesLength() -> NSInteger {
        return self.lengthOfBytes(using: .utf8)
    }
}
