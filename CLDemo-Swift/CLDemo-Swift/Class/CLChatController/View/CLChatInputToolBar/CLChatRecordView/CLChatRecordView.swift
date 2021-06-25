//
//  CLChatRecordView.swift
//  Potato
//
//  Created by AUG on 2019/12/10.
//

import UIKit
import SnapKit
import Lottie

class CLChatRecordView: UIView {
    ///时候可以发送录音
    var isCanSendCallBack: ((Bool) -> ())?
    ///开始录音
    var startRecorderCallBack: (() -> ())?
    ///取消录音
    var cancelRecorderCallBack: (() -> ())?
    ///结束录音
    var finishRecorderCallBack: ((TimeInterval, Data) -> ())?
    ///是否正在录制
    private (set) var isRecording: Bool = false
    ///是否可以发送
    private var isCanSend: Bool = true {
        didSet {
            if isCanSend != oldValue {
                isCanSendCallBack?(isCanSend)
            }
        }
    }
    ///底部背景
    private lazy var bottomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    ///底部安全区域
    private lazy var bottomSafeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    ///红圈
    private lazy var redcircle: UIView = {
        let redcircle = UIView()
        redcircle.layer.borderColor = UIColor.hex("0xff3b30").cgColor
        redcircle.layer.borderWidth = 1
        redcircle.layer.opacity = 0.45
        redcircle.layer.cornerRadius  = 90
        redcircle.layer.masksToBounds = true
        redcircle.isHidden = true
        return redcircle
    }()
    ///波纹动画
    private lazy var waveView: AnimationView = {
        let view = AnimationView.init(name: "recoredWave_dk")
        view.loopMode = .loop
        view.isHidden = true
        view.backgroundBehavior = .pauseAndRestore
        return view
    }()
    ///圆圈
    private lazy var circleView: UIView = {
        let circleView = UIView()
        circleView.backgroundColor = .hex("#2DD178")
        circleView.isUserInteractionEnabled = true
        circleView.layer.cornerRadius = 55
        circleView.layer.masksToBounds = true
        return circleView
    }()
    ///图标
    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView(image: UIImage.init(named: "icon_voice"))
        return iconImageView
    }()
    ///提示
    private lazy var tipsLabel: UILabel = {
        let tipsLabel = UILabel()
        tipsLabel.text = "按住说话"
        tipsLabel.textColor = UIColor.white
        tipsLabel.font = PingFangSCMedium(12)
        return tipsLabel
    }()
    ///时间
    private lazy var timeView: CLChatRecordTimeView = {
        let timeView = CLChatRecordTimeView()
        return timeView
    }()
    ///录音器
    private lazy var recorder: CLRecorder = {
        let recorder = CLRecorder()
        recorder.durationCallback = {[weak self] (second) in
            guard let `self` = self else { return }
            if second >= 60 {
                self.endLongPress()
            }
            self.timeView.time = self.transToHourMinSec(time: Int(second))
        }
        recorder.finishCallBack = {[weak self] (duration, path) in
            self?.finishRecorderCallBack?(TimeInterval(duration), path)
        }
        return recorder
    }()
    ///长按手势
    private lazy var longPress: UILongPressGestureRecognizer = {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.05
        return longPress
    }()
    ///是否超出范围
    private var isOut: Bool = false {
        willSet {
            if isOut != newValue {
                timeView.isOut = newValue
                if !newValue {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.prepare()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        generator.impactOccurred()
                    }
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatRecordView {
    private func initUI() {
        addSubview(bottomBackgroundView)
        addSubview(bottomSafeView)
        bottomBackgroundView.addSubview(redcircle)
        bottomBackgroundView.addSubview(waveView)
        bottomBackgroundView.addSubview(circleView)
        bottomBackgroundView.addSubview(iconImageView)
        bottomBackgroundView.addSubview(tipsLabel)
        bottomBackgroundView.addSubview(timeView)
        circleView.addGestureRecognizer(longPress)
    }
    private func makeConstraints() {
        bottomBackgroundView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(bottomSafeView.snp.top)
        }
        bottomSafeView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(safeAreaEdgeInsets.bottom)
        }
        redcircle.snp.makeConstraints { (make) in
            make.width.height.equalTo(180)
            make.center.equalToSuperview()
        }
        circleView.snp.makeConstraints { (make) in
            make.width.height.equalTo(110)
            make.center.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-6)
            make.width.equalTo(17)
            make.height.equalTo(25)
        }
        waveView.snp.makeConstraints { (make) in
            make.width.height.equalTo(164)
            make.center.equalToSuperview()
        }
        timeView.snp.makeConstraints { (make) in
            make.width.equalTo(87)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(circleView.snp.top)
        }
        tipsLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(6)
        }
    }
    private func playWave() {
        waveView.isHidden = false
        waveView.play()
        tipsLabel.isHidden = true
    }
    private func stopWave() {
        waveView.isHidden = true
        waveView.stop()
        tipsLabel.isHidden = false
    }
    private func zoomOut() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0,0.9]
        animation.duration = 0.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        circleView.layer.add(animation, forKey: "zoomOut")
    }
    private func zoomIn() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.9,1.0]
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.duration = 0.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        circleView.layer.add(animation, forKey: "zoomIn")
    }
}
extension CLChatRecordView {
    @objc private func handleLongPress() {
        let point: CGPoint = longPress.location(in: self)
        if timeView.isAnimationing {
            return
        }
        isOut = !redcircle.frame.contains(point)
        if longPress.state == .began {
            beganLongPress()
        }else if longPress.state == .changed {
            isCanSend = !isOut
            redcircle.isHidden = !isOut
        }else if longPress.state == .ended || longPress.state == .cancelled || longPress.state == .failed {
            endLongPress()
        }
    }
    private func beganLongPress() {
        if isRecording == false {
            isRecording = true
            playWave()
            zoomOut()
            timeView.show()
            startRecord()
        }
    }
    private func endLongPress() {
        if isRecording {
            isRecording = false
            stopWave()
            zoomIn()
            redcircle.isHidden = true
            timeView.dismiss()
            if isOut {
                cancelRecord()
            }else if recorder.audioDuration < 1.0 {
                cancelRecord()
                if CLPermissions.isAllowed(.microphone) {
                    CLPopupManager.showTips(text: "录音时间过短")
                }
            }else {
                endRecord()
            }
        }
    }
    private func transToHourMinSec(time: Int) -> String {
        var minutes = 0
        var seconds = 0
        var minutesText = ""
        var secondsText = ""
        minutes = time % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        seconds = time % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        return "\(minutesText):\(secondsText)"
    }
}
extension CLChatRecordView {
    private func startRecord() {
        if CLPermissions.isAllowed(.microphone) {
            self.recorder.start()
            self.startRecorderCallBack?()
        }else {
            CLPermissions.request(.microphone) { (status) in
                if status.isNoSupport {
                    CLPopupManager.showOneAlert(title: "当前设备不支持")
                }else if status.isAuthorized {
                }else {
                    CLPopupManager.showTwoAlert(title: "APP 需要访问麦克风才能录制语音消息\n\n请前往「设置—隐私—麦克风」中打开开关。", right: "设置", rightCallBack:  {
                        openSettings()
                    })
                }
            }
        }
    }
    private func cancelRecord() {
        recorder.cancel()
        cancelRecorderCallBack?()
    }
    private func endRecord() {
        recorder.stop()
    }
}
