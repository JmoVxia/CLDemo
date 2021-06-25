//
//  UILabel+Extension.swift
//  CL
//
//  Created by JmoVxia on 2020/5/22.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension UILabel {
    ///设置行间距
    func setLineSpacing(_ lineSpacing: CGFloat, alignment:  NSTextAlignment = .left) {
        guard let text = self.text else {return}
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = max(lineSpacing - (font.lineHeight - font.pointSize), 0)
        attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle : paragraphStyle])
    }
}
