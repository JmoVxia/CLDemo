//
//  CLCameraButton.swift
//  CLCamera
//
//  Created by Chen JmoVxia on 2024/2/21.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---枚举

extension CLCameraButton {}

// MARK: - JmoVxia---类-属性

class CLCameraButton: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var backgroundView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        view.layer.cornerRadius = intrinsicContentSize.width * 0.5
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var buttonCenterView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = (intrinsicContentSize.width - 20) * 0.5
        view.backgroundColor = .white
        return view
    }()

    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(origin: .zero, size: intrinsicContentSize)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineCap = .round
        layer.lineWidth = 5
        layer.strokeEnd = 0
        layer.path = {
            let progressLayerCenter = intrinsicContentSize.width * 0.5
            let progressLayerRadius = progressLayerCenter - 2.5
            return UIBezierPath(arcCenter: CGPoint(x: progressLayerCenter, y: progressLayerCenter),
                                radius: progressLayerRadius,
                                startAngle: .pi * -0.5,
                                endAngle: .pi * 1.5,
                                clockwise: true).cgPath
        }()
        return layer
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = CGRect(origin: .zero, size: intrinsicContentSize)
        layer.colors = [#colorLiteral(red: 0.9960784314, green: 0.6745098039, blue: 0.368627451, alpha: 1).cgColor, #colorLiteral(red: 0.7803921569, green: 0.4745098039, blue: 0.8156862745, alpha: 1).cgColor, #colorLiteral(red: 0.2941176471, green: 0.7529411765, blue: 0.7843137255, alpha: 1).cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.mask = progressLayer
        return layer
    }()
}

// MARK: - JmoVxia---布局

private extension CLCameraButton {
    func setupUI() {
        backgroundView.contentView.addSubview(buttonCenterView)
        addSubview(backgroundView)
        layer.addSublayer(gradientLayer)
    }

    func makeConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        buttonCenterView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(intrinsicContentSize.width - 20)
        }
    }
}

// MARK: - JmoVxia---override

extension CLCameraButton {
    override var intrinsicContentSize: CGSize {
        CGSize(width: 70, height: 70)
    }
}

// MARK: - JmoVxia---objc

@objc private extension CLCameraButton {}

// MARK: - JmoVxia---私有方法

private extension CLCameraButton {}

// MARK: - JmoVxia---公共方法

extension CLCameraButton {
    func showBeginAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.buttonCenterView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
    }

    func showEndAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = .identity
            self.buttonCenterView.transform = .identity
        })
        progressLayer.strokeEnd = 0
        progressLayer.removeAllAnimations()
    }

    func updateProgress(_ progress: CGFloat) {
        progressLayer.strokeEnd = progress
    }
}
