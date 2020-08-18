//
//  CLChatTextView.swift
//  Potato
//
//  Created by AUG on 2019/10/22.
//

import UIKit
import SnapKit

class CLChatTextView: UITextView {
    ///最大高度
    private var maxTextHeight: CGFloat {
        get {
            let textFont = font ?? PingFangSCMedium(15)
            return CGFloat(ceilf(Float(textFont.lineHeight * CGFloat(maxNumberOfLines) + textContainerInset.top + textContainerInset.bottom)))
        }
    }
    ///占位文字label
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.numberOfLines = 0
        return placeholderLabel
    }()
    ///最大行数
    var maxNumberOfLines: Int = 5
    ///占位文字
    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    ///占位文字颜色
    var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    ///文字变化回掉
    var textDidChangeCallBack: ((String)->())?
    ///字体
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    override var text: String! {
        didSet {
            textDidChange()
        }
    }
    ///高度变化回掉
    var textViewHeightChangeCallBack: ((CGFloat) -> ())?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension CLChatTextView {
    private func initUI() {
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().offset(-6)
            make.height.lessThanOrEqualToSuperview()
        }
        font = PingFangSCMedium(15)
        isScrollEnabled = false
        scrollsToTop = false
        showsHorizontalScrollIndicator = false;
        enablesReturnKeyAutomatically = true;
        //实时监听textView值得改变
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    @objc private func textDidChange() {
        textDidChangeCallBack?(text)
        placeholderLabel.isHidden = self.text.count > 0
        //计算高度
        setNeedsLayout()
        layoutIfNeeded()
        var height = CGFloat(ceilf(Float(sizeThatFits(CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))).height)))
        if height > maxTextHeight {
            height = maxTextHeight
            isScrollEnabled = true
        }else {
            isScrollEnabled = false
        }
        if frame.height != height {
            textViewHeightChangeCallBack?(height)
        }
        scrollRangeToVisible(NSRange(location: selectedRange.location, length: 1))
    }
}
extension CLChatTextView {
    
    
}
