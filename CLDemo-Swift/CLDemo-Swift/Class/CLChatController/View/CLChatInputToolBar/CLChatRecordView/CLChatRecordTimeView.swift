//
//  CLRecordTimeView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/1/28.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLChatRecordTimeView: UIView {
    private lazy var contentView: UIView = {
       let contentView = UIView()
        contentView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        return contentView
    }()
    private lazy var timeLabel: UILabel = {
       let timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.textColor = UIColor.white
        timeLabel.font = .monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        timeLabel.text = "00:00"
        return timeLabel
    }()
    private lazy var backgroundImageView: UIImageView = {
       let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage.init(named: "img_time")?.tintImage(.themeColor)
        return backgroundImageView
    }()
    private (set) var isAnimationing: Bool = false
    var isOut: Bool = false {
        didSet {
            if isOut != oldValue {
                if isOut {
                    timeLabel.textColor = .hex("0xff3b30")
                    backgroundImageView.image = UIImage.init(named: "img_time")?.tintImage(.hex("ffffff"))
                } else {
                    timeLabel.textColor = UIColor.white
                    backgroundImageView.image = UIImage.init(named: "img_time")?.tintImage(.themeColor)
                }
            }
        }
    }
    var time: String = "00:00" {
        didSet {
            if time != oldValue {
                timeLabel.text = time.isEmpty ? "00:00" : time
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
extension CLChatRecordTimeView {
    private func initUI() {
        addSubview(contentView)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(timeLabel)
    }
    private func makeConstraints() {
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
        }
    }
}
extension CLChatRecordTimeView {
    func show() {
        contentView.isHidden = false
        contentView.frame = bounds
        timeLabel.text = "00:00"
        let animation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        animation.fillMode = .forwards
        animation.values = [NSNumber(value: 0.2), NSNumber(value: 0.4), NSNumber(value: 0.8), NSNumber(value: 1.0), NSNumber(value: 1.2), NSNumber(value: 1.0)]
        animation.duration = 0.3
        animation.isRemovedOnCompletion = false
        contentView.layer.add(animation, forKey: "")
    }
    func dismiss() {
        isAnimationing = true
        contentView.frame = bounds
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.alpha = 0
        }) { finished in
            self.contentView.alpha = 1
            self.contentView.isHidden = true
            self.backgroundImageView.image = UIImage.init(named: "img_time")?.tintImage(.themeColor)
            self.timeLabel.textColor = UIColor.white
            self.isAnimationing = false
            self.timeLabel.text = "00:00"
        }
    }
}
