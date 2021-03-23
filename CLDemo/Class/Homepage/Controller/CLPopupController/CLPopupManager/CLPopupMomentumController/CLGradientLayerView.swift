//
//  CLGradientLayerView.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLGradientLayerView: UIView {
    var colors: [CGColor] = [CGColor]() {
        didSet {
            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            gradientLayer.colors = colors
        }
    }
    var startPoint: CGPoint? {
        didSet {
            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        }
    }
    var endPoint: CGPoint? {
        didSet {
            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
    }
    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
}
