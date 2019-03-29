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
    ///默认行数
    var defaultLine: NSInteger = 4
    ///最大行数
    var textViewMaxLine: NSInteger = 6
    ///最大字数
    var maxBytesLength: NSInteger = 520
    
    fileprivate class func defaultConfigure() -> CLTextViewConfigure {
        let configure = CLTextViewConfigure()
        return configure
    }
}

class CLTextView: UIView {
    ///输入框
    private let textView: UITextView = UITextView()
    ///计数label
    private let label: UILabel = UILabel()
    ///默认配置
    private let configure: CLTextViewConfigure = CLTextViewConfigure.defaultConfigure()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        
        textView.delegate = self
        addSubview(textView)
        
        label.backgroundColor = UIColor.orange
        textView.backgroundColor = UIColor.red
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        label.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.right.equalTo(-5)
        }
        textView.snp.makeConstraints({ (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(defaultHeight())
            make.bottom.equalTo(label.snp.top)
        })
        label.text = String.init(format: "0/%ld", configure.maxBytesLength)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///高度
    func defaultHeight() -> CGFloat {
        let lineH: CGFloat = textView.font!.lineHeight
        let textViewHeight: CGFloat = ceil(lineH * CGFloat(configure.defaultLine))
        return textViewHeight
    }
    
}

extension CLTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        if let rang = textView.markedTextRange {
            if let _ = textView.position(from: rang.start, offset: 0) {
                return
            }
        }
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
        label.text = string

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
