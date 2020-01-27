//
//  CLGradientLayerView.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLGradientLayerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [hexColor("0x373747").cgColor, hexColor("0x22222D").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
}
