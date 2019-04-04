//
//  CLTextView.swift
//  CLDemo
//
//  Created by AUG on 2019/3/28.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

/// 统计类型
///
/// - count: 字数
/// - bytesLength: 字节
enum Statistics: Int {
    case count
    case bytesLength
}

/// 字符编码格式
///
enum Encoding {
    case gbk
    case ascii
    case nextstep
    case japaneseEUC
    case utf8
    case isoLatin1
    case symbol
    case nonLossyASCII
    case shiftJIS
    case isoLatin2
    case unicode
    case windowsCP1251
    case windowsCP1252
    case windowsCP1253
    case windowsCP1254
    case windowsCP1250
    case iso2022JP
    case macOSRoman
    case utf16
    case utf16BigEndian
    case utf16LittleEndian
    case utf32
    case utf32BigEndian
    case utf32LittleEndian
}

class CLTextViewConfigure: NSObject {
    ///背景颜色
    var backgroundColor: UIColor = UIColor.white
    ///显示计数
    var showLengthLabel: Bool = false
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
    var maxCount = 1000
    ///最大字节
    var maxBytesLength: NSInteger = 520
    ///输入框间距
    var edgeInsets: UIEdgeInsets = .zero
    ///键盘风格
    var keyboardAppearance: UIKeyboardAppearance = .light
    ///统计类型
    var statistics: Statistics = .bytesLength
    ///编码格式
    var encoding: Encoding = .gbk
    
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
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.textColor = configure.textColor
        textView.tintColor = configure.cursorColor
        textView.keyboardAppearance = configure.keyboardAppearance
        textView.font = configure.textFont
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        textView.layoutManager.allowsNonContiguousLayout = false
        textView.scrollsToTop = false
        if #available(iOS 11.0, *) {
            textView.pasteDelegate = self
        }
        addSubview(textView)
        return textView
    }()
    ///占位文字laebl
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.textColor = configure.placeholderTextColor
        placeholderLabel.font = configure.textFont
        placeholderLabel.numberOfLines = 0
        placeholderLabel.text = configure.placeholder
        addSubview(placeholderLabel)
        return placeholderLabel
    }()
    ///计数label
    private lazy var lengthLabel: UILabel = {
        let lengthLabel = UILabel()
        lengthLabel.font = configure.lengthFont
        lengthLabel.text = String.init(format: "0/%ld", configure.maxBytesLength)
        addSubview(lengthLabel)
        return lengthLabel
    }()
    ///默认配置
    private let configure: CLTextViewConfigure = CLTextViewConfigure.defaultConfigure()
    ///输入的文字
    private (set) var text: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = configure.backgroundColor
        remakeConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///textView高度
    private func textViewHeight() -> CGFloat {
        let lineH: CGFloat = configure.textFont.lineHeight
        let contentSizeH: CGFloat = max(ceil(lineH * CGFloat(configure.defaultLine)), textView.contentSize.height)
        let maxTextViewHeight: CGFloat = ceil(lineH * CGFloat(configure.textViewMaxLine))
        return min(contentSizeH, maxTextViewHeight)
    }
    ///更新约束
    private func remakeConstraints() {
        DispatchQueue.main.async {
            self.lengthLabel.isHidden = !self.configure.showLengthLabel
            if self.configure.showLengthLabel {
                self.lengthLabel.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(self.snp.bottom).offset(self.configure.edgeInsets.bottom)
                    make.right.equalTo(self.configure.edgeInsets.right)
                }
            }
            self.textView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.configure.edgeInsets.top)
                make.left.equalTo(self.configure.edgeInsets.left)
                make.right.equalTo(self.configure.edgeInsets.right).priority(.low)
                make.height.equalTo(self.textViewHeight())
                if self.configure.showLengthLabel {
                    make.bottom.equalTo(self.lengthLabel.snp.top).offset(self.configure.edgeInsets.bottom).priority(.low)
                }else {
                    make.bottom.equalTo(self.snp.bottom).offset(self.configure.edgeInsets.bottom).priority(.low)
                }
            }
            self.placeholderLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(self.textView)
                make.left.equalTo(self.textView).offset(4)
                make.right.lessThanOrEqualTo(self.textView.snp.right).priority(.low)
                make.bottom.lessThanOrEqualTo(self.textView.snp.bottom)
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
            self.textView.scrollRangeToVisible(NSRange(location: self.textView.selectedRange.location, length: 1))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height: CGFloat = textViewHeight() + configure.edgeInsets.top - configure.edgeInsets.bottom + (configure.showLengthLabel ? (lengthLabel.sizeThatFits(.zero).height - configure.edgeInsets.bottom) : 0)
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: height)
    }
}
//MARK:JmoVxia---更新相关
extension CLTextView {
    ///更新默认配置
    func updateWithConfigure(_ configure: ((CLTextViewConfigure) -> Void)?) {
        configure?(self.configure)
        
        backgroundColor = self.configure.backgroundColor
        
        textView.textColor = self.configure.textColor
        textView.font = self.configure.textFont
        textView.tintColor = self.configure.cursorColor
        textView.keyboardAppearance = self.configure.keyboardAppearance
        
        placeholderLabel.text = self.configure.placeholder
        placeholderLabel.textColor = self.configure.placeholderTextColor
        placeholderLabel.font = self.configure.textFont
        
        lengthLabel.font = self.configure.lengthFont
        lengthLabel.textColor = self.configure.lengthColor
        
        remakeConstraints()
    }
    ///更新文字
    func updateText(_ text: String) {
        textView.text = text
        textViewDidChange(textView)
    }
}
//MARK:JmoVxia---UITextViewDelegate
extension CLTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.count > 0 ? true : false
        //输入状态不计算
        if let rang = textView.markedTextRange {
            if let _ = textView.position(from: rang.start, offset: 0) {
                return
            }
        }
        //记录
        let startString: String = String.init(stringLiteral: text)
        //限制字数
        if textView.text.count > configure.maxCount {
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
        if bytesLength(text: textView.text) > configure.maxBytesLength {
            var range: NSRange
            var byteLength: NSInteger = 0
            var i = 0
            while i < textView.text.utf16.count && byteLength <= configure.maxBytesLength {
                range = (textView.text as NSString).rangeOfComposedCharacterSequence(at: i)
                byteLength += bytesLength(text: (textView.text as NSString).substring(with: range))
                if (byteLength > configure.maxBytesLength) {
                    let newText = (textView.text as NSString).substring(with: NSRange.init(location: 0, length: range.location))
                    textView.text = newText
                }
                i += range.length
            }
        }
        
        text = textView.text
        var string: String
        if configure.statistics == .bytesLength {
            string = String.init(format: "%ld/%ld",  bytesLength(text: textView.text), configure.maxBytesLength)
        }else {
            string = String.init(format: "%ld/%ld", textView.text.count, configure.maxCount)
        }
        
        lengthLabel.text = string
        
        remakeConstraints()
        
        if  startString != textView.text {
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
//MARK:JmoVxia---键盘相关
extension CLTextView {
    ///成为第一响应者
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    ///取消第一响应者
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
}
extension CLTextView {
    func bytesLength(text: String) -> Int {
        switch configure.encoding {
        case .gbk:
            return text.gbkLength()
        case .ascii:
            return text.bytesLength(using: .ascii)
        case .nextstep:
            return text.bytesLength(using: .nextstep)
        case .japaneseEUC:
            return text.bytesLength(using: .japaneseEUC)
        case .utf8:
            return text.bytesLength(using: .utf8)
        case .isoLatin1:
            return text.bytesLength(using: .isoLatin1)
        case .symbol:
            return text.bytesLength(using: .symbol)
        case .nonLossyASCII:
            return text.bytesLength(using: .nonLossyASCII)
        case .shiftJIS:
            return text.bytesLength(using: .shiftJIS)
        case .isoLatin2:
            return text.bytesLength(using: .isoLatin2)
        case .unicode:
            return text.bytesLength(using: .unicode)
        case .windowsCP1251:
            return text.bytesLength(using: .windowsCP1251)
        case .windowsCP1252:
            return text.bytesLength(using: .windowsCP1252)
        case .windowsCP1253:
            return text.bytesLength(using: .windowsCP1253)
        case .windowsCP1254:
            return text.bytesLength(using: .windowsCP1254)
        case .windowsCP1250:
            return text.bytesLength(using: .windowsCP1250)
        case .iso2022JP:
            return text.bytesLength(using: .iso2022JP)
        case .macOSRoman:
            return text.bytesLength(using: .macOSRoman)
        case .utf16:
            return text.bytesLength(using: .utf16)
        case .utf16BigEndian:
            return text.bytesLength(using: .utf16BigEndian)
        case .utf16LittleEndian:
            return text.bytesLength(using: .utf16LittleEndian)
        case .utf32:
            return text.bytesLength(using: .utf32)
        case .utf32BigEndian:
            return text.bytesLength(using: .utf32BigEndian)
        case .utf32LittleEndian:
            return text.bytesLength(using: .utf32LittleEndian)
        }
    }
}
extension String {
    ///用GBK编码长度
    func gbkLength() -> Int {
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
        let gbkData = (self as NSString).data(using: encoding)!
        let gbkBytes = [UInt8](gbkData)
        return gbkBytes.count
    }
    ///按照编码获取对应字节
    func bytesLength(using: String.Encoding) -> NSInteger {
        return self.lengthOfBytes(using: using)
    }
}
extension CLTextView: UITextPasteDelegate {
    @available(iOS 11.0, *)
    func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting, shouldAnimatePasteOf attributedString: NSAttributedString, to textRange: UITextRange) -> Bool {
        return false
    }
}
