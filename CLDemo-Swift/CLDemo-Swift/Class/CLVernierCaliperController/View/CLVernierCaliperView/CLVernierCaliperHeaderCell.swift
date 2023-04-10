//
//  CLVernierCaliperHeaderCell.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLVernierCaliperHeaderCell: UICollectionViewCell {
    var minValue: CGFloat = 0.0
    var unit: String = ""
    var long: CGFloat = 0.0
    var textFont: UIFont = .mediumPingFangSC(14)
    var limitDecimal: NSDecimalNumber = .init(value: 0)
}

extension CLVernierCaliperHeaderCell {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor("#999999").cgColor)
        context?.setLineWidth(1.0)
        context?.setLineCap(CGLineCap.butt)
        context?.move(to: CGPoint(x: rect.size.width, y: 0))
        let minString = NSDecimalNumber(value: Double(minValue)).stringFormatter(withExample: limitDecimal)
        let numberString = String(format: "%@%@", minString, unit)
        let attribute: Dictionary = [.font: textFont, NSAttributedString.Key.foregroundColor: UIColor("#999999")]
        let width = numberString.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions(rawValue: 0), attributes: attribute, context: nil).size.width
        numberString.draw(in: CGRect(x: rect.width - width * 0.5, y: rect.height - CGFloat(long) + 10, width: width, height: textFont.lineHeight), withAttributes: attribute)
        context?.addLine(to: CGPoint(x: rect.width, y: CGFloat(long)))
        context?.strokePath()
    }
}
