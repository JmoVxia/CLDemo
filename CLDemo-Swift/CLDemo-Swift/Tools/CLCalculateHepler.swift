//
//  CLCalculateHepler.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/7/15.
//

import UIKit

class CLCalculateHepler: NSObject {
    private static let label = UILabel()
    ///计算高度
    class func height(with text: String, font: UIFont, numberOfLines: Int = 0, lineBreakMode: NSLineBreakMode = .byCharWrapping, maxWidth: CGFloat) -> CGFloat {
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        label.font = font
        label.text = text
        return label.sizeThatFits(CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))).height
    }
    ///计算高度
    class func height(with attributedText: NSAttributedString, numberOfLines: Int = 0, lineBreakMode: NSLineBreakMode = .byCharWrapping, maxWidth: CGFloat) -> CGFloat {
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        label.attributedText = attributedText
        return label.sizeThatFits(CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))).height
    }
}
