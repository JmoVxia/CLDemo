//
//  CLVernierCaliperMiddleCell.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLVernierCaliperMiddleCell: UICollectionViewCell {
    var minValue: CGFloat = 0.0
    var maxValue: CGFloat = 0.0
    var unit: String = ""
    var minimumUnit: CGFloat = 0.0
    var unitInterval: Int = 0
    var gap: Int = 0
    var long: CGFloat = 0.0
    var short: CGFloat = 0.0
    var textFont: UIFont = PingFangSCMedium(14)
    var limitDecimal: NSDecimalNumber = NSDecimalNumber(0)
}
extension CLVernierCaliperMiddleCell {
        override func draw(_ rect: CGRect) {
            let startX: CGFloat  = 0
            let lineCenterX: CGFloat = CGFloat(gap)
            let topY: CGFloat = 0
            let context = UIGraphicsGetCurrentContext()
            context?.setLineWidth(1)
            context?.setLineCap(CGLineCap.butt)
            context?.setStrokeColor(UIColor.hex("#999999").cgColor)
            for i in 0...unitInterval {
                context?.move(to: CGPoint.init(x: startX + lineCenterX * CGFloat(i), y: topY))
                if i % unitInterval == 0 {
                    let number = CGFloat(i) * minimumUnit + minValue
                    let limitString = NSDecimalNumber(value: Double(number)).stringFormatter(withExample: limitDecimal)
                    let numberString = String(format: "%@%@", limitString, unit)
                    let attribute: Dictionary = [.font : textFont, NSAttributedString.Key.foregroundColor : UIColor.hex("#999999")]
                    let width = numberString.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attribute,context: nil).size.width
                    numberString.draw(in: CGRect.init(x: startX + lineCenterX * CGFloat(i) - width * 0.5, y: rect.height - CGFloat(long) + 10, width: width, height: textFont.lineHeight), withAttributes: attribute)
                    context!.addLine(to: CGPoint.init(x: startX + lineCenterX * CGFloat(i), y: CGFloat(long)))
                }else{
                    context!.addLine(to: CGPoint.init(x: startX + lineCenterX * CGFloat(i), y: CGFloat(short)))
                }
                context!.strokePath()
            }
    }
}
