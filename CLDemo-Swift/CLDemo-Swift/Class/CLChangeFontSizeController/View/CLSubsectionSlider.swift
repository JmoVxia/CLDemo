//
//  CLSubsectionSlider.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/15.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---类-属性

class CLSubsectionSlider: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var changeCallback: ((Int) -> Void)?
    var endCallback: ((Int) -> Void)?
    /// 点击手势
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sliderDidTap(_:)))
        return gesture
    }()

    /// 背景
    private lazy var sliderBackgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "fontSizeSlider")
        return view
    }()

    /// slider
    private lazy var slider: UISlider = {
        let view = UISlider()
        view.minimumValue = 1
        view.maximumValue = 6
        view.minimumTrackTintColor = .clear
        view.maximumTrackTintColor = .clear
        view.setValue(Float(CLFontManager.fontSizeCoefficient), animated: false)
        view.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        view.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
        view.addTarget(self, action: #selector(sliderTouchUp(_:)), for: .touchUpInside)
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    /// 左边label
    private lazy var leftLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .mediumPingFangSC(13, scale: false)
        view.text = "A"
        return view
    }()

    /// 标准label
    private lazy var standardLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray
        view.font = .mediumPingFangSC(15.5, scale: false)
        view.text = "标准"
        return view
    }()

    /// 右边label
    private lazy var rightLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .mediumPingFangSC(24, scale: false)
        view.text = "A"
        return view
    }()

    /// 上次滑动的值
    private var lastScrollValue: Int = CLFontManager.fontSizeCoefficient {
        didSet {
            if lastScrollValue != oldValue {
                CLFontManager.setFontSizeCoefficient(lastScrollValue)
                changeCallback?(lastScrollValue)
            }
        }
    }

    /// 上次点击的值
    private var lastTapValue: Int = CLFontManager.fontSizeCoefficient {
        didSet {
            if lastTapValue != oldValue {
                CLFontManager.setFontSizeCoefficient(lastTapValue)
                endCallback?(lastTapValue)
            }
        }
    }
}

// MARK: - JmoVxia---布局

private extension CLSubsectionSlider {
    func initUI() {
        addSubview(sliderBackgroundImageView)
        addSubview(slider)
        addSubview(leftLabel)
        addSubview(standardLabel)
        addSubview(rightLabel)
    }

    func makeConstraints() {
        slider.snp.makeConstraints { make in
            make.left.equalTo(35)
            make.right.equalTo(-35)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        sliderBackgroundImageView.snp.makeConstraints { make in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(8)
            make.centerY.equalToSuperview()
        }
        leftLabel.snp.makeConstraints { make in
            make.centerX.equalTo(sliderBackgroundImageView.snp.left)
            make.centerY.equalTo(25)
        }
        standardLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.right).multipliedBy(0.2).offset(15)
            make.centerY.equalTo(leftLabel)
        }
        rightLabel.snp.makeConstraints { make in
            make.centerX.equalTo(sliderBackgroundImageView.snp.right)
            make.centerY.equalTo(leftLabel)
        }
    }
}

// MARK: - JmoVxia---点击事件

private extension CLSubsectionSlider {
    @objc func sliderValueChanged(_ sender: UISlider) {
        let coefficient = lroundf(sender.value)
        slider.setValue(Float(coefficient), animated: false)
        lastScrollValue = coefficient
    }

    @objc func sliderTouchDown(_ sender: UISlider) {
        tapGesture.isEnabled = false
    }

    @objc func sliderTouchUp(_ sender: UISlider) {
        tapGesture.isEnabled = true
        let coefficient = lroundf(sender.value)
        slider.setValue(Float(coefficient), animated: false)
        lastTapValue = coefficient
    }

    @objc func sliderDidTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        let coefficient = lroundf(Float((point.x - 15) / (slider.frame.width - 30) * 5)) + 1
        slider.setValue(Float(coefficient), animated: false)
        lastTapValue = coefficient
    }
}
