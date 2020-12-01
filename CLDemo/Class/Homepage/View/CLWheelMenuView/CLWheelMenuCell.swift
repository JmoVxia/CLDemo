//
//  CLMenuLayer.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLWheelMenuCell: UIView {
    var isSelected: Bool = false {
        didSet {
            if oldValue != isSelected {
                imageView.image = isSelected ? item?.selectedImage : item?.image
            }
        }
    }
    let path: UIBezierPath = UIBezierPath()
    var item: CLWheelMenuItem? {
        didSet {
            updateUI()
        }
    }
    private (set) var contentsTransform: CATransform3D!
    private (set) lazy var contentView: UIView = {
        let view = UIView()
        view.layer.transform = contentsTransform
        view.backgroundColor = .clear
        return view
    }()
    private (set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    init(frame: CGRect, startAngle: CGFloat, endAngle: CGFloat, contentsTransform: CATransform3D) {
        super.init(frame: frame)
        self.contentsTransform = contentsTransform
        setMaskLayer(startAngle, endAngle: endAngle)
        initUI()
        makeConstraints()
    }
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLWheelMenuCell {
    func setMaskLayer(_ startAngle: CGFloat, endAngle: CGFloat) {
        let center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        let layer = CAShapeLayer()
        path.addArc(withCenter: center, radius: bounds.width * 0.5, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLine(to: center)
        layer.path = path.cgPath
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
        self.layer.mask = layer
    }
    func initUI() {
        addSubview(contentView)
        contentView.addSubview(imageView)
    }
    func makeConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(12)
            make.size.equalTo(45)
        }
    }
    func updateUI() {
        backgroundColor = item?.backgroundColor
        imageView.image = isSelected ? item?.selectedImage : item?.image
    }
}
