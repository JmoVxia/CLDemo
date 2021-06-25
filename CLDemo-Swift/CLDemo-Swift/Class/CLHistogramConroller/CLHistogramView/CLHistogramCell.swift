//
//  CLHistogramCell.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLHistogramCell: UITableViewCell {
    struct CLHistogramItem {
        var morning: NSDecimalNumber = 0.0
        var noon: NSDecimalNumber = 0.0
        var night: NSDecimalNumber = 0.0
        var additional: NSDecimalNumber = 0.0
        var total: NSDecimalNumber {
            return morning.adding(noon).adding(night).adding(additional)
        }
        var isMorningNomal: Bool {
            return morning.lessThen(1.0)
        }
        var isNoonNomal: Bool {
            return morning.adding(noon).lessThen(1.0)
        }
        var isNightNomal: Bool {
            return morning.adding(noon).adding(night).lessThen(1.0)
        }
        var isAdditionalNomal: Bool {
            return morning.adding(noon).adding(night).adding(additional).lessThen(1.0)
        }
    }
    var item: CLHistogramItem = CLHistogramItem() {
        didSet {
            if oldValue.morning != item.morning ||
               oldValue.noon != item.noon ||
               oldValue.night != item.night ||
               oldValue.additional != item.additional {
                DispatchQueue.main.async {
                    self.drawLayer()
                }
            }
        }
    }
    var name: String = "" {
        didSet {
            if oldValue != name {
                nameLabel.text = name
            }
        }
    }
    
    private var maxValue: CGFloat = 1.8
    private var leftRightEdge: CGFloat = 60
    private var middleSpace: CGFloat = 10
    private var layerHeight: CGFloat = 12
    private var cornerRadius: CGFloat = 3
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = PingFangSCMedium(10)
        view.textColor = .lightGray
        view.textAlignment = .right
        return view
    }()
    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.contentsScale = UIScreen.main.scale
        layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        return layer
    }()
    private lazy var animationLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    private lazy var morningLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.hex("#ADE1D0").cgColor
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    private lazy var noonLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.hex("#79C9AE").cgColor
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    private lazy var nightLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.hex("#3B9778").cgColor
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    private lazy var additionalLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.hex("#20BC88").cgColor
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    private lazy var exceedLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.hex("#F57629").cgColor
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    private lazy var seriousExceedLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.hex("#BE0909").cgColor
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    private lazy var oneThirdLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.red.cgColor
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    private lazy var twoThirdLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.red.cgColor
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()
    private lazy var springAnimation: CASpringAnimation = {
        let animation = CASpringAnimation(keyPath: "transform.scale.x")
        animation.mass = 0.6
        animation.stiffness = 80
        animation.damping = 10
        animation.initialVelocity = 0.5
        animation.duration = 1.25
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.6, 0.1, 0.30, 0.90)
        return animation
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLHistogramCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        let x = leftRightEdge + middleSpace
        let y = (bounds.height - layerHeight) * 0.5
        let width = bounds.width - (leftRightEdge + middleSpace) * 2
        backgroundLayer.frame = CGRect(x: x, y: y, width: width, height: layerHeight)
        animationLayer.frame = backgroundLayer.bounds
        morningLayer.frame = animationLayer.bounds
        noonLayer.frame = animationLayer.bounds
        nightLayer.frame = animationLayer.bounds
        additionalLayer.frame = animationLayer.bounds
        exceedLayer.frame = animationLayer.bounds
        seriousExceedLayer.frame = animationLayer.bounds
        oneThirdLayer.frame = CGRect(x: width * 1.0 / maxValue * 1.0 / 3.0, y: layerHeight - 5, width: 1, height: 5)
        twoThirdLayer.frame = CGRect(x: width * 1.0 / maxValue * 2.0 / 3.0, y: layerHeight - 5, width: 1, height: 5)
    }
}
private extension CLHistogramCell {
    func initUI() {
        selectionStyle = .none
        isExclusiveTouch = true
        contentView.addSubview(nameLabel)
        contentView.layer.addSublayer(backgroundLayer)
        backgroundLayer.addSublayer(animationLayer)
        animationLayer.addSublayer(morningLayer)
        animationLayer.addSublayer(noonLayer)
        animationLayer.addSublayer(nightLayer)
        animationLayer.addSublayer(additionalLayer)
        animationLayer.addSublayer(exceedLayer)
        animationLayer.addSublayer(seriousExceedLayer)
        animationLayer.addSublayer(oneThirdLayer)
        animationLayer.addSublayer(twoThirdLayer)
    }
    func makeConstraints() {
        nameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(leftRightEdge)
            make.left.centerY.equalToSuperview()
        }
    }
}
private extension CLHistogramCell {
    func drawLayer() {
        let width = (bounds.width - (leftRightEdge + middleSpace) * 2) * 1.0 / maxValue
        
        let morningRadius: CGFloat = (item.isMorningNomal && item.morning.moreThen(0.0) && (item.noon.adding(item.night).adding(item.additional)) == 0.0) ? cornerRadius : 0
        let morningWidth = width * CGFloat(min(item.morning.floatValue, 1.0))
        morningLayer.path = UIBezierPath(radius: .init(topLeft: 0, topRight: morningRadius, bottomLeft: 0, bottomRight: morningRadius), width: morningWidth, height: layerHeight).cgPath
        
        let noonRadius: CGFloat = (item.isNoonNomal && item.noon.moreThen(0.0) && (item.night.adding(item.additional)) == 0.0) ? cornerRadius : 0
        let noonWidth = width * CGFloat(min(item.morning.adding(item.noon).floatValue, 1.0))
        noonLayer.path = UIBezierPath(radius: .init(topLeft: 0, topRight: noonRadius, bottomLeft: 0, bottomRight: noonRadius), edgeInsets: UIEdgeInsets(top: 0, left: morningWidth, bottom: 0, right: 0), width: noonWidth, height: layerHeight).cgPath

        let nightRadius: CGFloat = (item.isNightNomal && item.night.moreThen(0.0) && item.additional == 0.0) ? cornerRadius : 0
        let nightWidth = width * CGFloat(min(item.morning.adding(item.noon).adding(item.night).floatValue, 1.0))
        nightLayer.path = UIBezierPath(radius: .init(topLeft: 0, topRight: nightRadius, bottomLeft: 0, bottomRight: nightRadius), edgeInsets: UIEdgeInsets(top: 0, left: noonWidth, bottom: 0, right: 0), width: nightWidth, height: layerHeight).cgPath

        let additionalRadius: CGFloat = (item.isAdditionalNomal && item.additional.moreThen(0.0)) ? cornerRadius : 0
        let additionalWidth = width * CGFloat(min(item.total.floatValue, 1.0))
        additionalLayer.path = UIBezierPath(radius: .init(topLeft: 0, topRight: additionalRadius, bottomLeft: 0, bottomRight: additionalRadius), edgeInsets: UIEdgeInsets(top: 0, left: nightWidth, bottom: 0, right: 0), width: additionalWidth, height: layerHeight).cgPath
        
        let exceedRadius: CGFloat = (item.total.lessThen(1.5) && item.total.moreThen(1.0)) ? cornerRadius : 0
        let exceedWidth = width * CGFloat(min(item.total.floatValue, 1.5))
        exceedLayer.path = UIBezierPath(radius: .init(topLeft: 0, topRight: exceedRadius, bottomLeft: 0, bottomRight: exceedRadius), edgeInsets: UIEdgeInsets(top: 0, left: additionalWidth, bottom: 0, right: 0), width: exceedWidth, height: layerHeight).cgPath

        let seriousExceedRadius: CGFloat = item.total.moreThen(1.5) ? cornerRadius : 0
        let seriousExceedWidth = width * CGFloat(min(item.total.floatValue, 1.8))
        seriousExceedLayer.path = UIBezierPath(radius: .init(topLeft: 0, topRight: seriousExceedRadius, bottomLeft: 0, bottomRight: seriousExceedRadius), edgeInsets: UIEdgeInsets(top: 0, left: exceedWidth, bottom: 0, right: 0), width: seriousExceedWidth, height: layerHeight).cgPath
        
        animationLayer.add(springAnimation, forKey: "springAnimation")
    }
}
