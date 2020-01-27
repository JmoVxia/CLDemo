//
//  CLChatInputToolBar.swift
//  Potato
//
//  Created by AUG on 2019/10/22.
//

import UIKit
import SnapKit

protocol CLChatInputToolBarDelegate: class {
    ///键盘发送文字
    func inputBarWillSendText(text: String)
    ///键盘将要显示
    func inputBarWillShowKeyboard()
    ///键盘将要隐藏
    func inputBarWillHiddenKeyboard()
    ///点击相册按钮
    func inputBarClickAlbum()
    ///点击相机按钮
    func inputBarClickCamera()
    ///点击录音按钮
    func inputBarClickRecord()
    ///开始录音
    func inputBarStartRecord()
    ///录音定时器调用
    func inputBarRecordTime() -> TimeInterval?
    ///取消录音
    func inputBarCancelRecord()
    ///结束录音
    func inputBarFinishRecord()
}
extension CLChatInputToolBarDelegate {
    ///键盘发送文字
    func inputBarWillSendText(text: String) {
        
    }
    ///键盘将要显示
    func inputBarWillShowKeyboard() {
        
    }
    ///键盘将要隐藏
    func inputBarWillHiddenKeyboard() {
        
    }
    ///点击相册按钮
    func inputBarClickAlbum() {
        
    }
    ///点击相机按钮
    func inputBarClickCamera() {
        
    }
    ///点击录音按钮
    func inputBarClickRecord() {
        
    }
    ///开始录音
    func inputBarStartRecord() {
        
    }
    ///录音定时器调用
    func inputBarRecordTime() -> TimeInterval? {
        return nil
    }
    ///取消录音
    func inputBarCancelRecord() {
        
    }
    ///结束录音
    func inputBarFinishRecord() {
        
    }
}

class CLChatInputToolBar: UIView {
    ///内容视图
    private lazy var contentView: UIView = {
        let contentView = UIView()
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: cl_screenWidth(), height: 1)
        topBorder.backgroundColor = hexColor("0x22222D").cgColor
        contentView.layer.addSublayer(topBorder)
        return contentView
    }()
    ///顶部工具条
    private lazy var topToolBar: UIView = {
        let topToolBar = UIView()
        topToolBar.backgroundColor = hexColor("0x31313F")
        return topToolBar
    }()
    ///中间内容视图
    private lazy var middleSpaceView: UIView = {
        let middleSpaceView = UIView()
        middleSpaceView.backgroundColor = hexColor("0x31313F")
        return middleSpaceView
    }()
    ///底部安全区域
    private lazy var bottomSafeView: UIView = {
        let bottomSafeView = UIView()
        bottomSafeView.backgroundColor = hexColor("0x31313F")
        return bottomSafeView
    }()
    ///图片按钮
    private lazy var photoButton: UIButton = {
        let photoButton = UIButton()
        photoButton.adjustsImageWhenHighlighted = false
        photoButton.setImage(UIImage.init(named: "btn_knocktalk_photo"), for: .normal)
        photoButton.setImage(UIImage.init(named: "btn_knocktalk_photo"), for: .selected)
        photoButton.addTarget(self, action: #selector(photoButtonAction), for: .touchUpInside)
        return photoButton
    }()
    ///表情按钮
    private lazy var emojiButton: UIButton = {
        let emojiButton = UIButton()
        emojiButton.adjustsImageWhenHighlighted = false
        emojiButton.setImage(UIImage.init(named: "btn_knocktalk_expression"), for: .normal)
        emojiButton.setImage(UIImage.init(named: "btn_knocktalk_expression"), for: .selected)
        emojiButton.addTarget(self, action: #selector(emojiButtonAction), for: .touchUpInside)
        return emojiButton
    }()
    ///录音按钮
    private lazy var recordButton: UIButton = {
        let recordButton = UIButton()
        recordButton.adjustsImageWhenHighlighted = false
        recordButton.setImage(UIImage.init(named: "btn_knocktalk_voice"), for: .normal)
        recordButton.setImage(UIImage.init(named: "btn_knocktalk_voice"), for: .selected)
        recordButton.addTarget(self, action: #selector(recordButtonAction), for: .touchUpInside)
        return recordButton
    }()
    ///发送按钮
    private lazy var sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.isHidden = true
        sendButton.adjustsImageWhenHighlighted = false
        sendButton.setImage(UIImage.init(named: "btn_knocktalk_send"), for: .normal)
        sendButton.setImage(UIImage.init(named: "btn_knocktalk_send"), for: .selected)
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return sendButton
    }()
    ///输入框
    private lazy var textView: CLChatTextView = {
        let textView = CLChatTextView()
        textView.backgroundColor = UIColor.clear
        textView.autocapitalizationType = .none
        textView.enablesReturnKeyAutomatically = true
        textView.layoutManager.allowsNonContiguousLayout = false
        textView.scrollsToTop = false
        textView.delegate = self
        textView.returnKeyType = .send
        textView.autocorrectionType = .no
        textView.textColor = hexColor("0xBABAE2")
        textView.keyboardAppearance = .dark
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textViewHeightChangeCallBack = {[weak self] (height) in
            self?.textViewHeightChange(height: height)
        }
        textView.textDidChangeCallBack = {[weak self](text) in
            self?.isHiddenSend = text.isEmpty || (text as NSString).isValidAllEmpty()
        }
        return textView
    }()
    ///线条
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = hexColor("0x4A4A6A")
        return lineView
    }()
    ///表情view
    private lazy var emojiView: CLChatEmojiView = {
        let emojiView = CLChatEmojiView()
        emojiView.autoresizesSubviews = false
        emojiView.backgroundColor = hexColor("0x31313F")
        emojiView.didSelectEmojiCallBack = {[weak self] (emoji) in
            guard let strongSelf = self else {
                return
            }
            if let selectedTextRange = strongSelf.textView.selectedTextRange {
                strongSelf.textView .replace(selectedTextRange, withText: emoji)
            }
        }
        emojiView.didSelectDeleteCallBack = {[weak self] in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.textView.deleteBackward()
            }
        }
        return emojiView
    }()
    ///图片view
    private lazy var photoView: CLChatPhotoView = {
        let photoView = CLChatPhotoView()
        photoView.backgroundColor = hexColor("0x31313F")
        photoView.albumButtonCallback = {[weak self] in
            self?.delegate?.inputBarClickAlbum()
        }
        photoView.cameraButtonCallback = {[weak self] in
            self?.delegate?.inputBarClickCamera()
        }
        return photoView
    }()
    ///录音
    private lazy var recordView: CLChatRecordView = {
        let recordView = CLChatRecordView()
        recordView.backgroundColor = hexColor("0x31313F")
        recordView.startRecorderCallBack = {[weak self] in
            self?.delegate?.inputBarStartRecord()
        }
        recordView.recorderTimeCallBack = {[weak self] in
            return self?.delegate?.inputBarRecordTime()
        }
        recordView.cancelRecorderCallBack = {[weak self] in
            self?.delegate?.inputBarCancelRecord()
        }
        recordView.finishRecorderCallBack = {[weak self] in
            self?.delegate?.inputBarFinishRecord()
        }
        return recordView
    }()
    ///是否弹出键盘
    private var isShowKeyboard: Bool = false {
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
                animateView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
                    animateView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: nil)
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
    }
    ///是否显示表情键盘
    private var isShowEmojiKeyboard: Bool = false
    ///是否显示录音键盘
    private var isShowVoiceKeyboard: Bool = false {
        willSet {
            if isShowVoiceKeyboard != newValue {
                voiceKeyboard(show: newValue)
            }
        }
    }
    ///是否显示文字键盘
    private var isShowTextKeyboard: Bool = false
    ///是否正在旋转
    private var isTransition: Bool = false
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
            return textViewDefaultHeight + 10 + 10 + cl_safeAreaInsets().bottom
        }
    }
    ///文字大小
    var textFont: UIFont = UIFont.systemFont(ofSize: 13) {
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
    var placeholderColor: UIColor = hexColor("0x5C5C71") {
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
        backgroundColor = hexColor("0x31313F")
        addSubview(contentView)
        contentView.addSubview(topToolBar)
        contentView.addSubview(middleSpaceView)
        contentView.addSubview(bottomSafeView)
        
        topToolBar.addSubview(photoButton)
        topToolBar.addSubview(emojiButton)
        topToolBar.addSubview(recordButton)
        topToolBar.addSubview(sendButton)
        topToolBar.addSubview(textView)
        topToolBar.addSubview(lineView)
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
        topToolBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
        }
        middleSpaceView.snp.makeConstraints { (make) in
            make.top.equalTo(topToolBar.snp.bottom)
            make.left.right.equalTo(contentView)
            make.height.equalTo(0)
        }
        bottomSafeView.snp.makeConstraints { (make) in
            make.top.equalTo(middleSpaceView.snp.bottom)
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(cl_safeAreaInsets().bottom)
        }
        photoButton.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.width.height.equalTo(textViewHeight + 10)
            make.bottom.equalTo(lineView.snp.bottom)
        }
        emojiButton.snp.makeConstraints { (make) in
            make.left.equalTo(photoButton.snp.right).offset(12)
            make.width.height.equalTo(textViewHeight + 10)
            make.bottom.equalTo(lineView.snp.bottom)
        }
        recordButton.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.width.height.equalTo(textViewHeight + 10)
            make.bottom.equalTo(lineView.snp.bottom)
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
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(textView)
            make.height.equalTo(0.5)
            make.top.equalTo(textView.snp.bottom).offset(5)
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
        var keyboardHeight: CGFloat = keyboardRect.height - cl_safeAreaInsets().bottom
        if isShowEmojiKeyboard {
            keyboardHeight = emojiView.height - cl_safeAreaInsets().bottom
        }
        if isShowPhotoKeyboard {
            keyboardHeight = photoView.height
        }
        if isShowVoiceKeyboard {
            keyboardHeight = recordView.height
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
        if isShowPhotoKeyboard || isShowVoiceKeyboard || isTransition {
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
            delegate?.inputBarClickRecord()
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
    @objc private func sendButtonAction() {
        if !(textView.text as NSString).isValidAllEmpty() {
            delegate?.inputBarWillSendText(text: textView.text)
            textView.text = ""
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
                make.height.equalTo(photoView.height)
                make.top.equalTo(contentView.snp.bottom)
            }
            setNeedsLayout()
            layoutIfNeeded()
            UIView.animate(withDuration: 0.25) {
                self.photoView.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(self.contentView)
                    make.height.equalTo(self.photoView.height)
                    make.top.equalTo(self.contentView.snp.bottom).offset(-self.photoView.height - cl_safeAreaInsets().bottom)
                }
                self.middleSpaceView.snp.updateConstraints { (make) in
                    make.height.equalTo(self.photoView.height)
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
                make.height.equalTo(recordView.height)
                make.top.equalTo(contentView.snp.bottom)
            }
            setNeedsLayout()
            layoutIfNeeded()
            UIView.animate(withDuration: 0.25) {
                self.recordView.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(self.contentView)
                    make.height.equalTo(self.recordView.height)
                    make.top.equalTo(self.contentView.snp.bottom).offset(-self.recordView.height - cl_safeAreaInsets().bottom)
                }
                self.middleSpaceView.snp.updateConstraints { (make) in
                    make.height.equalTo(self.recordView.height)
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
//MARK: - JmoVxia---对外接口
extension CLChatInputToolBar {
    ///控制器将要旋转
    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        isTransition = true
        coordinator.animate(alongsideTransition: nil) { (_) in
            self.isTransition = false
        }
        emojiView.viewWillTransition(to: size, with: coordinator)
    }
    ///隐藏键盘
    func dismissKeyboard() {
        isShowPhotoKeyboard = false
        isShowEmojiKeyboard = false
        isShowVoiceKeyboard = false
        middleSpaceView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        UIView.animate(withDuration: 0.25) {
            self.superview?.setNeedsLayout()
            self.superview?.layoutIfNeeded()
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
