//
//  CLTextView.swift
//
//
//  Created by AUG on 2019/3/28.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import SnapKit
import UIKit

extension CLTextViewConfig {
    /// 统计类型
    ///
    /// - count: 字数
    /// - bytesLength: 字节
    enum Statistics: Int {
        case count
        case bytesLength
    }

    /// 字符编码格式
    enum Encoding {
        case gbk
        case bytesLength(using: String.Encoding)
    }
}

class CLTextViewConfig: NSObject {
    /// 背景颜色
    var backgroundColor: UIColor = .white
    /// 显示计数
    var showLengthLabel: Bool = true
    /// 占位文字
    var placeholder: String = "请输入文字"
    /// 占位文字颜色
    var placeholderTextColor: UIColor = .black
    /// text字体
    var textFont: UIFont = .systemFont(ofSize: 12)
    /// textView颜色
    var textColor: UIColor = .black
    /// 光标颜色
    var cursorColor: UIColor = .blue
    /// 计数label字体
    var lengthFont: UIFont = .systemFont(ofSize: 12)
    /// 计数label字体颜色
    var lengthColor: UIColor = .black
    /// 默认行数
    var defaultLine: NSInteger = 3
    /// 最大行数
    var textViewMaxLine: NSInteger = 6
    /// 最大字数
    var maxCount: NSInteger = 100
    /// 最大字节
    var maxBytesLength: NSInteger = 520
    /// 输入框间距
    var edgeInsets: UIEdgeInsets = .zero
    /// 键盘风格
    var keyboardAppearance: UIKeyboardAppearance = .light
    /// 统计类型
    var statistics: Statistics = .bytesLength
    /// 编码格式
    var encoding: Encoding = .gbk

    fileprivate class func defaultConfigure() -> CLTextViewConfig {
        let configure = CLTextViewConfig()
        return configure
    }
}

protocol CLTextViewDelegate: AnyObject {
    /// 输入改变
    func textViewDidChange(textView: CLTextView) -> Void
    /// 开始输入
    func textViewBeginEditing(textView: CLTextView) -> Void
    /// 结束输入
    func textViewEndEditing(textView: CLTextView) -> Void
}

class CLTextView: UIView {
    /// 代理
    weak var delegate: CLTextViewDelegate?
    /// 高度
    var height: CGFloat {
        return textViewHeight() + config.edgeInsets.top - config.edgeInsets.bottom + (config.showLengthLabel ? (lengthLabel.sizeThatFits(.zero).height - config.edgeInsets.bottom) : 0)
    }

    /// 输入框
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.backgroundColor = .clear
        view.textColor = config.textColor
        view.tintColor = config.cursorColor
        view.keyboardAppearance = config.keyboardAppearance
        view.font = config.textFont
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
        view.layoutManager.allowsNonContiguousLayout = false
        view.scrollsToTop = false
        if #available(iOS 11.0, *) {
            view.pasteDelegate = self
        }
        addSubview(view)
        return view
    }()

    /// 占位文字laebl
    private lazy var placeholderLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.textColor = config.placeholderTextColor
        view.font = config.textFont
        view.numberOfLines = 0
        view.text = config.placeholder
        addSubview(view)
        return view
    }()

    /// 计数label
    private lazy var lengthLabel: UILabel = {
        let view = UILabel()
        view.font = config.lengthFont
        if config.statistics == .bytesLength {
            view.text = String(format: "0/%ld", config.maxBytesLength)
        } else {
            view.text = String(format: "0/%ld", config.maxCount)
        }
        addSubview(view)
        return view
    }()

    /// 默认配置
    private let config: CLTextViewConfig = .defaultConfigure()
    /// 上一次输入的文字
    private var lastText: String = ""
    /// 当前输入的文字
    private(set) var text: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = config.backgroundColor
        remakeConstraints()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
        addGestureRecognizer(tapGestureRecognizer)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// textView高度
    private func textViewHeight() -> CGFloat {
        let lineH: CGFloat = config.textFont.lineHeight
        let contentSize = textView.sizeThatFits(CGSize(width: bounds.size.width - config.edgeInsets.left + config.edgeInsets.right, height: 0))
        let contentSizeH: CGFloat = max(ceil(lineH * CGFloat(config.defaultLine)), contentSize.height)
        let maxTextViewHeight: CGFloat = ceil(lineH * CGFloat(config.textViewMaxLine))
        return min(contentSizeH, maxTextViewHeight)
    }

    /// 更新约束
    private func remakeConstraints() {
        DispatchQueue.main.async {
            self.lengthLabel.isHidden = !self.config.showLengthLabel
            if self.config.showLengthLabel {
                self.lengthLabel.snp.remakeConstraints { make in
                    make.bottom.equalTo(self.snp.bottom).offset(self.config.edgeInsets.bottom)
                    make.right.equalTo(self.config.edgeInsets.right)
                }
            }
            self.textView.snp.remakeConstraints { make in
                make.top.equalTo(self.config.edgeInsets.top)
                make.left.equalTo(self.config.edgeInsets.left)
                make.right.equalTo(self.config.edgeInsets.right)
                make.height.equalTo(self.textViewHeight())
                if self.config.showLengthLabel {
                    make.bottom.equalTo(self.lengthLabel.snp.top).offset(self.config.edgeInsets.bottom)
                } else {
                    make.bottom.equalTo(self.snp.bottom).offset(self.config.edgeInsets.bottom)
                }
            }
            self.placeholderLabel.snp.remakeConstraints { make in
                make.top.equalTo(self.textView)
                make.left.equalTo(self.textView).offset(4)
                make.right.lessThanOrEqualTo(self.textView.snp.right)
                make.bottom.lessThanOrEqualTo(self.textView.snp.bottom)
            }
            self.textView.scrollRangeToVisible(NSRange(location: self.textView.selectedRange.location, length: 1))
        }
    }
}

// MARK: JmoVxia---更新相关

extension CLTextView {
    /// 更新默认配置
    func updateWithConfig(_ config: ((CLTextViewConfig) -> Void)?) {
        config?(self.config)

        backgroundColor = self.config.backgroundColor

        textView.textColor = self.config.textColor
        textView.font = self.config.textFont
        textView.tintColor = self.config.cursorColor
        textView.keyboardAppearance = self.config.keyboardAppearance

        placeholderLabel.text = self.config.placeholder
        placeholderLabel.textColor = self.config.placeholderTextColor
        placeholderLabel.font = self.config.textFont

        lengthLabel.font = self.config.lengthFont
        lengthLabel.textColor = self.config.lengthColor

        remakeConstraints()
    }

    /// 更新文字
    func updateText(_ text: String) {
        textView.text = text
        textViewDidChange(textView)
    }
}

// MARK: JmoVxia---UITextViewDelegate

extension CLTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard !text.isEmpty else { return true }

        if let rang = textView.markedTextRange,
           textView.position(from: rang.start, offset: 0) != nil
        {
            return true
        }

        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if (newText.count > config.maxCount) || (bytesLength(text: newText) > config.maxBytesLength) || (bytesLength(text: newText) == 0 && newText.count > 0) {
            return false
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        DispatchQueue.main.async {
            // 输入状态不计算
            self.placeholderLabel.isHidden = textView.text.count > 0 ? true : false

            if let rang = textView.markedTextRange,
               textView.position(from: rang.start, offset: 0) != nil
            {
                return
            }
            // 超过限制,恢复上一次文字
            if (textView.text.count > self.config.maxCount) || (self.bytesLength(text: textView.text) > self.config.maxBytesLength) || (self.bytesLength(text: textView.text) == 0 && textView.text.count > 0) {
                textView.text = self.lastText
            } else {
                self.lastText = textView.text
            }
            let lengthText: String = {
                if self.config.statistics == .bytesLength {
                    return String(format: "%ld/%ld", self.bytesLength(text: textView.text), self.config.maxBytesLength)
                } else {
                    return String(format: "%ld/%ld", textView.text.count, self.config.maxCount)
                }
            }()
            self.lengthLabel.text = lengthText
            self.remakeConstraints()
            if self.lastText != self.text {
                self.text = textView.text
                self.delegate?.textViewDidChange(textView: self)
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewBeginEditing(textView: self)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewEndEditing(textView: self)
    }
}

// MARK: JmoVxia---键盘相关

extension CLTextView {
    /// 成为第一响应者
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }

    /// 取消第一响应者
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }

    /// 可以成为第一响应者
    override var canBecomeFirstResponder: Bool {
        return textView.canBecomeFirstResponder
    }

    /// 可以注销第一响应者
    override var canResignFirstResponder: Bool {
        return textView.canResignFirstResponder
    }
}

extension CLTextView {
    func bytesLength(text: String) -> Int {
        switch config.encoding {
        case .gbk:
            return text.gbkLength()
        case let .bytesLength(using: encoding):
            return text.bytesLength(using: encoding)
        }
    }
}

extension String {
    /// 用GBK编码长度
    func gbkLength() -> Int {
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
        let gbkData = (self as NSString).data(using: encoding)!
        let gbkBytes = [UInt8](gbkData)
        return gbkBytes.count
    }

    /// 按照编码获取对应字节
    func bytesLength(using: String.Encoding) -> NSInteger {
        return lengthOfBytes(using: using)
    }
}

extension CLTextView: UITextPasteDelegate {
    @available(iOS 11.0, *)
    func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting, shouldAnimatePasteOf attributedString: NSAttributedString, to textRange: UITextRange) -> Bool {
        return false
    }
}
