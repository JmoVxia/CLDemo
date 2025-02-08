//
//  CLLoadingProgressView.swift
//  CLCamera
//
//  Created by Chen JmoVxia on 2024/2/26.
//

import UIKit

// MARK: - JmoVxia---枚举

extension CLLoadingProgressView {}

// MARK: - JmoVxia---类-属性

class CLLoadingProgressView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.opacity = 1
        layer.lineCap = CAShapeLayerLineCap.round
        layer.lineWidth = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.5
        return layer
    }()

    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
            isHidden = progress == 1
        }
    }
}

// MARK: - JmoVxia---布局

private extension CLLoadingProgressView {
    func setupUI() {
        backgroundColor = .clear
        layer.addSublayer(progressLayer)
    }

    func makeConstraints() {}
}

// MARK: - JmoVxia---override

extension CLLoadingProgressView {
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.size.width * 0.5, y: rect.size.height * 0.5)
        let radius = rect.size.width * 0.5

        let startAngle = -Double.pi / 2
        let endAngle = -Double.pi / 2 + Double.pi * 2 * progress
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        progressLayer.frame = bounds
        progressLayer.path = path.cgPath
    }
}

// MARK: - JmoVxia---objc

@objc private extension CLLoadingProgressView {}

// MARK: - JmoVxia---私有方法

private extension CLLoadingProgressView {}

// MARK: - JmoVxia---公共方法

extension CLLoadingProgressView {}
