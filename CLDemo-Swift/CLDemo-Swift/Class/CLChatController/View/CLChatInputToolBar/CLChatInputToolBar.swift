//
//  CLChatInputToolBar.swift
//  Potato
//
//  Created by AUG on 2019/10/22.
//

import UIKit
import SnapKit
import Photos

protocol CLChatInputToolBarDelegate: AnyObject {
    ///键盘发送文字
    func inputBarWillSendText(text: String)
    ///键盘发送图片
    func inputBarWillSendImage(images: [(image: UIImage, asset: PHAsset)])
    ///键盘将要显示
    func inputBarWillShowKeyboard()
    ///键盘将要隐藏
    func inputBarWillHiddenKeyboard()
    ///开始录音
    func inputBarStartRecord()
    ///取消录音
    func inputBarCancelRecord()
    ///结束录音
    func inputBarFinishRecord(duration: TimeInterval, file: Data)
}
extension CLChatInputToolBarDelegate {
    ///键盘发送文字
    func inputBarWillSendText(text: String) {
        
    }
    ///键盘发送图片
    func inputBarWillSendImage(images: [(image: UIImage, asset: PHAsset)]) {
        
    }
    ///键盘将要显示
    func inputBarWillShowKeyboard() {
        
    }
    ///键盘将要隐藏
    func inputBarWillHiddenKeyboard() {
        
    }
    ///开始录音
    func inputBarStartRecord() {
        
    }
    ///取消录音
    func inputBarCancelRecord() {
        
    }
    ///结束录音
    func inputBarFinishRecord(duration: TimeInterval, file: Data) {
        
    }
}

class CLChatInputToolBar: UIView {
    ///内容视图
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    ///顶部线条
    private lazy var topLineView: UIView = {
        let topLineView = UIView()
        topLineView.backgroundColor = .hex("#DADADA")
        return topLineView
    }()
    ///顶部工具条
    private lazy var topToolBar: UIView = {
        let topToolBar = UIView()
        topToolBar.backgroundColor = .hex("#F6F6F6")
        return topToolBar
    }()
    ///中间内容视图
    private lazy var middleSpaceView: UIView = {
        let middleSpaceView = UIView()
        middleSpaceView.backgroundColor = .hex("#F6F6F6")
        return middleSpaceView
    }()
    ///底部安全区域
    private lazy var bottomSafeView: UIView = {
        let bottomSafeView = UIView()
        bottomSafeView.backgroundColor = .hex("#F6F6F6")
        return bottomSafeView
    }()
    ///更多按钮
    private lazy var moreButton: UIButton = {
        let view = UIButton()
        view.expandClickEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        view.adjustsImageWhenHighlighted = false
        view.setBackgroundImage(UIImage.init(named: "addIcon"), for: .normal)
        view.setBackgroundImage(UIImage.init(named: "addIcon"), for: .selected)
        view.addTarget(self, action: #selector(photoButtonAction), for: .touchUpInside)
        return view
    }()
    ///more键盘按钮
    private lazy var moreKeyboardButton: UIButton = {
        let view = UIButton()
        view.expandClickEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        view.isHidden = true
        view.adjustsImageWhenHighlighted = false
        view.setBackgroundImage(UIImage.init(named: "keyboard"), for: .normal)
        view.setBackgroundImage(UIImage.init(named: "keyboard"), for: .selected)
        view.addTarget(self, action: #selector(photoButtonAction), for: .touchUpInside)
        return view
    }()
    ///表情按钮
    private lazy var emojiButton: UIButton = {
        let view = UIButton()
        view.expandClickEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        view.adjustsImageWhenHighlighted = false
        view.setBackgroundImage(UIImage.init(named: "facialIcon"), for: .normal)
        view.setBackgroundImage(UIImage.init(named: "facialIcon"), for: .selected)
        view.addTarget(self, action: #selector(emojiButtonAction), for: .touchUpInside)
        return view
    }()
    ///emoji键盘按钮
    private lazy var emojiKeyboardButton: UIButton = {
        let view = UIButton()
        view.expandClickEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        view.isHidden = true
        view.adjustsImageWhenHighlighted = false
        view.setBackgroundImage(UIImage.init(named: "keyboard"), for: .normal)
        view.setBackgroundImage(UIImage.init(named: "keyboard"), for: .selected)
        view.addTarget(self, action: #selector(emojiButtonAction), for: .touchUpInside)
        return view
    }()
    ///录音按钮
    private lazy var recordButton: UIButton = {
        let view = UIButton()
        view.expandClickEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        view.adjustsImageWhenHighlighted = false
        view.setBackgroundImage(UIImage.init(named: "voiceIcon"), for: .normal)
        view.setBackgroundImage(UIImage.init(named: "voiceIcon"), for: .selected)
        view.addTarget(self, action: #selector(recordButtonAction), for: .touchUpInside)
        return view
    }()
    ///录音键盘按钮
    private lazy var recordKeyboardButton: UIButton = {
        let view = UIButton()
        view.expandClickEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        view.isHidden = true
        view.adjustsImageWhenHighlighted = false
        view.setBackgroundImage(UIImage.init(named: "keyboard"), for: .normal)
        view.setBackgroundImage(UIImage.init(named: "keyboard"), for: .selected)
        view.addTarget(self, action: #selector(recordButtonAction), for: .touchUpInside)
        return view
    }()
    ///发送按钮
    private lazy var sendButton: UIButton = {
        let view = UIButton()
        view.expandClickEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        view.isHidden = true
        view.adjustsImageWhenHighlighted = false
        view.setBackgroundImage(UIImage.init(named: "sendIcon"), for: .normal)
        view.setBackgroundImage(UIImage.init(named: "sendIcon"), for: .selected)
        view.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return view
    }()
    ///输入框
    private lazy var textView: CLChatTextView = {
        let view = CLChatTextView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.autocapitalizationType = .none
        view.enablesReturnKeyAutomatically = true
        view.layoutManager.allowsNonContiguousLayout = false
        view.scrollsToTop = false
        view.delegate = self
        view.returnKeyType = .send
        view.autocorrectionType = .no
        view.textColor = .black
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom:8, right: 8)
        view.textContainer.lineFragmentPadding = 0
        view.textViewHeightChangeCallBack = {[weak self] (height) in
            self?.textViewHeightChange(height: height)
        }
        view.textDidChangeCallBack = {[weak self](text) in
            self?.isHiddenSend = text.isEmpty || (text).isValidAllEmpty()
            self?.emojiView.isCanSend = !(text.isEmpty || (text).isValidAllEmpty())
            self?.emojiView.isCanDelete = !text.isEmpty
        }
        return view
    }()
    ///表情view
    private lazy var emojiView: CLChatEmojiView = {
        let view = CLChatEmojiView()
        view.backgroundColor = .hex("#EEEEED")
        view.autoresizesSubviews = false
        view.didSelectEmojiCallBack = {[weak self] (emoji) in
            guard let strongSelf = self else { return }
            if let selectedTextRange = strongSelf.textView.selectedTextRange {
                strongSelf.textView .replace(selectedTextRange, withText: emoji)
            }
        }
        view.didSelectDeleteCallBack = {[weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.textView.deleteBackward()
            }
        }
        view.didSelectSendCallBack = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.sendButtonAction()
        }
        return view
    }()
    ///图片view
    private lazy var photoView: CLChatPhotoView = {
        let view = CLChatPhotoView()
        view.backgroundColor = .hex("#EEEEED")
        view.sendImageCallBack = {[weak self] (images) in
            self?.delegate?.inputBarWillSendImage(images: images)
        }
        return view
    }()
    ///录音提示view
    private lazy var recordTipsView: CLChatRecordTipsView = {
        let view = CLChatRecordTipsView()
        view.backgroundColor = .hex("#EEEEED")
        return view
    }()
    ///是否显示提示
    private var isShowTips: Bool = false
    ///录音
    private lazy var recordView: CLChatRecordView = {
        let view = CLChatRecordView()
        view.backgroundColor = .hex("#EEEEED")
        view.startRecorderCallBack = {[weak self] in
            self?.delegate?.inputBarStartRecord()
            self?.showRecordTips()
        }
        view.cancelRecorderCallBack = {[weak self] in
            self?.delegate?.inputBarCancelRecord()
            self?.hiddenRecordTips()
        }
        view.finishRecorderCallBack = {[weak self] (duration, data) in
            self?.delegate?.inputBarFinishRecord(duration: duration, file: data)
            self?.hiddenRecordTips()
        }
        view.isCanSendCallBack = {[weak self] (isCanSend) in
            self?.recordTipsView.isCanSend = isCanSend
        }
        return view
    }()
    ///是否弹出键盘
    private (set) var isShowKeyboard: Bool = false {
        willSet {
            if isShowKeyboard != newValue {
                if newValue == true {
                    delegate?.inputBarWillShowKeyboard()
                }else {
                    delegate?.inputBarWillHiddenKeyboard()
                }
            }
        }
    }
    ///是否隐藏发送按钮
    private var isHiddenSend: Bool = true {
        didSet {
            if isHiddenSend != oldValue {
                sendButton.isHidden = isHiddenSend
                recordButton.isHidden = !isHiddenSend
                let animateView = isHiddenSend ? recordButton : sendButton
                transformanimAnimate(with: animateView)
            }
        }
    }
    ///第一次显示
    private var isFristShowEmoji: Bool = true
    ///是否显示图片键盘
    private var isShowPhotoKeyboard: Bool = false {
        willSet {
            if isShowPhotoKeyboard != newValue {
                photoKeyboard(show: newValue)
            }
        }
        didSet {
            if isShowPhotoKeyboard != oldValue {
                moreButton.isHidden = isShowPhotoKeyboard
                moreKeyboardButton.isHidden = !isShowPhotoKeyboard
                let animateView = isShowPhotoKeyboard ? moreKeyboardButton : moreButton
                transformanimAnimate(with: animateView)
            }
        }
    }
    ///是否显示表情键盘
    private var isShowEmojiKeyboard: Bool = false {
        didSet {
            if isShowEmojiKeyboard != oldValue {
                emojiButton.isHidden = isShowEmojiKeyboard
                emojiKeyboardButton.isHidden = !isShowEmojiKeyboard
                let animateView = isShowEmojiKeyboard ? emojiKeyboardButton : emojiButton
                transformanimAnimate(with: animateView)
            }
        }
    }
    ///是否显示录音键盘
    private var isShowVoiceKeyboard: Bool = false {
        willSet {
            if isShowVoiceKeyboard != newValue {
                voiceKeyboard(show: newValue)
            }
        }
        didSet {
            if isShowVoiceKeyboard != oldValue {
                recordButton.isHidden = isShowVoiceKeyboard
                recordKeyboardButton.isHidden = !isShowVoiceKeyboard
                let animateView = isShowVoiceKeyboard ? recordKeyboardButton : recordButton
                transformanimAnimate(with: animateView)
            }
        }
    }
    ///是否显示文字键盘
    private var isShowTextKeyboard: Bool = false
    ///输入框默认大小
    private var textViewDefaultHeight: CGFloat {
        get {
            return CGFloat(ceilf(Float(textFont.lineHeight + textView.textContainerInset.top + textView.textContainerInset.bottom)))
        }
    }
    ///输入框改变后大小
    private var textViewChangedHeight: CGFloat = 0.0
    ///输入框大小
    var textViewHeight: CGFloat {
        get {
            return max(textViewDefaultHeight, textViewChangedHeight)
        }
    }
    ///初始高度
    var toolBarDefaultHeight: CGFloat {
        get {
            return textViewDefaultHeight + 15 + 15 + safeAreaEdgeInsets.bottom
        }
    }
    ///文字大小
    var textFont: UIFont = PingFangSCMedium(15) {
        didSet {
            textView.font = textFont
        }
    }
    ///最大行数
    var maxNumberOfLines: Int = 5 {
        didSet {
            textView.maxNumberOfLines = maxNumberOfLines
        }
    }
    ///占位文字
    var placeholder: String = "" {
        didSet {
            textView.placeholder = placeholder
        }
    }
    ///占位文字颜色
    var placeholderColor: UIColor = .hex("0x5C5C71") {
        didSet {
            textView.textColor = placeholderColor
        }
    }
    ///代理
    weak var delegate: CLChatInputToolBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
        addNotification()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
//MARK: - JmoVxia---初始化
extension CLChatInputToolBar {
    private func initUI() {
        backgroundColor = .hex("#F6F6F6")
        addSubview(contentView)
        addSubview(topLineView)
        contentView.addSubview(topToolBar)
        contentView.addSubview(recordTipsView)
        contentView.addSubview(middleSpaceView)
        contentView.addSubview(bottomSafeView)
        
        topToolBar.addSubview(moreButton)
        topToolBar.addSubview(moreKeyboardButton)
        topToolBar.addSubview(emojiButton)
        topToolBar.addSubview(emojiKeyboardButton)
        topToolBar.addSubview(recordButton)
        topToolBar.addSubview(recordKeyboardButton)
        topToolBar.addSubview(sendButton)
        topToolBar.addSubview(textView)
    }
    private func makeConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            if #available(iOS 11.0, *) {
                make.left.equalTo(safeAreaLayoutGuide.snp.left)
                make.right.equalTo(safeAreaLayoutGuide.snp.right)
            } else {
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
            }
        }
        topLineView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(1)
        }
        topToolBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
        }
        recordTipsView.snp.makeConstraints { (make) in
            make.size.left.equalTo(topToolBar)
            make.top.equalTo(topToolBar.snp.bottom)
        }
        middleSpaceView.snp.makeConstraints { (make) in
            make.top.equalTo(topToolBar.snp.bottom)
            make.left.right.equalTo(contentView)
            make.height.equalTo(0)
        }
        bottomSafeView.snp.makeConstraints { (make) in
            make.top.equalTo(middleSpaceView.snp.bottom)
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(safeAreaEdgeInsets.bottom)
        }
        moreButton.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.width.height.equalTo(textViewHeight - 8)
            make.bottom.equalTo(textView.snp.bottom).offset(-4)
        }
        moreKeyboardButton.snp.makeConstraints { (make) in
            make.edges.equalTo(moreButton)
        }
        emojiButton.snp.makeConstraints { (make) in
            make.left.equalTo(moreButton.snp.right).offset(12)
            make.width.height.equalTo(textViewHeight - 8)
            make.bottom.equalTo(textView.snp.bottom).offset(-4)
        }
        emojiKeyboardButton.snp.makeConstraints { (make) in
            make.edges.equalTo(emojiButton)
        }
        recordButton.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.width.height.equalTo(textViewHeight - 8)
            make.bottom.equalTo(textView.snp.bottom).offset(-4)
        }
        recordKeyboardButton.snp.makeConstraints { (make) in
            make.edges.equalTo(recordButton)
        }
        sendButton.snp.makeConstraints { (make) in
            make.edges.equalTo(recordButton)
        }
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(emojiButton.snp.right).offset(12)
            make.right.equalTo(recordButton.snp.left).offset(-12)
            make.height.equalTo(textViewHeight)
            make.top.equalTo(15)
            make.bottom.equalTo(topToolBar.snp.bottom).offset(-15)
        }
    }
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
//MARK: - JmoVxia---键盘监听
extension CLChatInputToolBar {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval, let options = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSInteger else {return}
        var keyboardHeight: CGFloat = keyboardRect.height - safeAreaEdgeInsets.bottom
        if isShowEmojiKeyboard {
            keyboardHeight = emojiView.height - safeAreaEdgeInsets.bottom
        }
        if isShowPhotoKeyboard {
            keyboardHeight = emojiView.height - safeAreaEdgeInsets.bottom
        }
        if isShowVoiceKeyboard {
            keyboardHeight = emojiView.height  - safeAreaEdgeInsets.bottom
        }
        middleSpaceView.snp.updateConstraints { (make) in
            make.height.equalTo(keyboardHeight)
        }
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(options)), animations: {
            self.superview?.setNeedsLayout()
            self.superview?.layoutIfNeeded()
        })
    }
    @objc private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval, let options = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSInteger else {return}
        if isShowPhotoKeyboard || isShowVoiceKeyboard {
            return
        }
        isShowEmojiKeyboard = false
        middleSpaceView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        UIView.animate(withDuration: duration, delay: 0, options:UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(options)) , animations: {
            self.superview?.setNeedsLayout()
            self.superview?.layoutIfNeeded()
        }, completion: { (_) in
            self.textView.inputView = nil;
        })
    }
}
//MARK: - JmoVxia---UI改变
extension CLChatInputToolBar {
    private func textViewHeightChange(height: CGFloat) {
        textViewChangedHeight = height
        textView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
}
//MARK: - JmoVxia---录音提示工具条
extension CLChatInputToolBar {
    private func showRecordTips() {
        guard !isShowTips else {
            return
        }
        isShowTips.toggle()
        recordTipsView.snp.remakeConstraints { (make) in
            make.size.left.equalTo(topToolBar)
            make.top.equalTo(topToolBar.snp.bottom)
        }
        setNeedsLayout()
        layoutIfNeeded()
        UIView.animate(withDuration: 0.1) {
            self.recordTipsView.snp.remakeConstraints { (make) in
                make.edges.equalTo(self.topToolBar)
            }
            self.contentView.setNeedsLayout()
            self.contentView.layoutIfNeeded()
        }
    }
    private func hiddenRecordTips() {
        guard isShowTips else {
            return
        }
        isShowTips.toggle()
        recordTipsView.snp.remakeConstraints { (make) in
            make.edges.equalTo(topToolBar)
        }
        setNeedsLayout()
        layoutIfNeeded()
        UIView.animate(withDuration: 0.1) {
            self.recordTipsView.snp.remakeConstraints { (make) in
                make.size.left.equalTo(self.topToolBar)
                make.top.equalTo(self.topToolBar.snp.bottom)
            }
            self.contentView.setNeedsLayout()
            self.contentView.layoutIfNeeded()
        } completion: { (_) in
            self.recordTipsView.isCanSend = true
        }
    }
}
//MARK: - JmoVxia---按钮点击事件
extension CLChatInputToolBar {
    @objc private func photoButtonAction() {
        isShowEmojiKeyboard = false
        isShowVoiceKeyboard = false
        contentView.addSubview(photoView)
        if isShowPhotoKeyboard == false {
            isShowPhotoKeyboard = true
            textViewResignFirstResponder()
            textView.inputView = nil
        }else {
            isShowPhotoKeyboard = false
            isShowEmojiKeyboard = textView.inputView == emojiView
            isShowTextKeyboard = !isShowEmojiKeyboard
            textViewBecomeFirstResponder()
        }
    }
    @objc private func recordButtonAction() {
        isShowEmojiKeyboard = false
        isShowPhotoKeyboard = false
        contentView.addSubview(recordView)
        if isShowVoiceKeyboard == false {
            isShowVoiceKeyboard = true
            textViewResignFirstResponder()
            textView.inputView = nil
        }else {
            isShowVoiceKeyboard = false
            isShowEmojiKeyboard = textView.inputView == emojiView
            isShowTextKeyboard = !isShowEmojiKeyboard
            textViewBecomeFirstResponder()
        }
    }
    @objc private func sendButtonAction() {
        if !(textView.text).isValidAllEmpty() {
            delegate?.inputBarWillSendText(text: textView.text)
            textView.text = ""
        }
    }
    @objc private func emojiButtonAction() {
        isShowPhotoKeyboard = false
        isShowVoiceKeyboard = false
        if isShowEmojiKeyboard == false {
            textView.inputView = emojiView
        }else {
            textView.inputView = nil
        }
        isShowEmojiKeyboard = !isShowEmojiKeyboard
        textViewBecomeFirstResponder()
        if isFristShowEmoji {
            isFristShowEmoji = false
            textView.reloadInputViews()
        }else {
            UIView.animate(withDuration: 0.25) {
                self.textView.reloadInputViews()
            }
        }
    }
    private func keyboardChange() {
        isShowKeyboard = isShowPhotoKeyboard || isShowEmojiKeyboard || isShowVoiceKeyboard || isShowTextKeyboard
    }
    private func photoKeyboard(show: Bool) {
        contentView.addSubview(photoView)
        if show {
            photoView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(contentView)
                make.height.equalTo(emojiView.height)
                make.top.equalTo(contentView.snp.bottom)
            }
            setNeedsLayout()
            layoutIfNeeded()
            UIView.animate(withDuration: 0.25) {
                self.photoView.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(self.contentView)
                    make.height.equalTo(self.emojiView.height)
                    make.top.equalTo(self.contentView.snp.bottom).offset(-self.emojiView.height)
                }
                self.middleSpaceView.snp.updateConstraints { (make) in
                    make.height.equalTo(self.emojiView.height - safeAreaEdgeInsets.bottom)
                }
                self.superview?.setNeedsLayout()
                self.superview?.layoutIfNeeded()
            }
        }else {
            UIView.animate(withDuration: 0.25) {
                self.photoView.snp.updateConstraints { (make) in
                    make.top.equalTo(self.contentView.snp.bottom)
                }
                self.superview?.setNeedsLayout()
                self.superview?.layoutIfNeeded()
            }
        }
    }
    private func voiceKeyboard(show: Bool) {
        contentView.addSubview(recordView)
        if show {
            recordView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(contentView)
                make.height.equalTo(emojiView.height)
                make.top.equalTo(contentView.snp.bottom)
            }
            setNeedsLayout()
            layoutIfNeeded()
            UIView.animate(withDuration: 0.25) {
                self.recordView.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(self.contentView)
                    make.height.equalTo(self.emojiView.height)
                    make.top.equalTo(self.contentView.snp.bottom).offset(-self.emojiView.height)
                }
                self.middleSpaceView.snp.updateConstraints { (make) in
                    make.height.equalTo(self.emojiView.height - safeAreaEdgeInsets.bottom)
                }
                self.superview?.setNeedsLayout()
                self.superview?.layoutIfNeeded()
            }
        }else {
            UIView.animate(withDuration: 0.25) {
                self.recordView.snp.updateConstraints { (make) in
                    make.top.equalTo(self.contentView.snp.bottom)
                }
                self.superview?.setNeedsLayout()
                self.superview?.layoutIfNeeded()
            }
        }
    }
    private func textViewBecomeFirstResponder() {
        textView.becomeFirstResponder()
        isShowEmojiKeyboard = textView.inputView == emojiView
        isShowTextKeyboard = !isShowEmojiKeyboard
        keyboardChange()
    }
    private func textViewResignFirstResponder() {
        textView.resignFirstResponder()
        isShowTextKeyboard = false
        keyboardChange()
    }
}
extension CLChatInputToolBar {
    private func transformanimAnimate(with animateView: UIView) {
        animateView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            animateView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
}
//MARK: - JmoVxia---对外接口
extension CLChatInputToolBar {
    ///隐藏键盘
    func dismissKeyboard() {
        isShowPhotoKeyboard = false
        isShowEmojiKeyboard = false
        isShowVoiceKeyboard = false
        
        middleSpaceView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.superview?.setNeedsLayout()
            self.superview?.layoutIfNeeded()
        }) { (_) in
            self.photoView.hiddenAlbumContentView()
            self.emojiView.restoreInitialState()
        }
        textViewResignFirstResponder()
    }
}
extension CLChatInputToolBar: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        isShowPhotoKeyboard = false
        isShowVoiceKeyboard = false
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewBecomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewResignFirstResponder()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sendButtonAction()
            return false
        }
        return true
    }
}
