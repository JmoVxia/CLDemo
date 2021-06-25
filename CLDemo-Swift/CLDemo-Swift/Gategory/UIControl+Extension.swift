//
//  UIControl+Extension.swift
//  CL
//
//  Created by JmoVxia on 2020/5/29.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension UIControl {
    private struct AssociatedKey {
        static var expandClickEdgeInsets: String = "expandClickEdgeInsets"
    }
    ///扩大点击区域
    var expandClickEdgeInsets: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.expandClickEdgeInsets) as? UIEdgeInsets ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.expandClickEdgeInsets, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let biggerFrame = CGRect(x: bounds.minX - expandClickEdgeInsets.left, y: bounds.minY - expandClickEdgeInsets.top, width: bounds.width + expandClickEdgeInsets.left + expandClickEdgeInsets.right, height: bounds.height + expandClickEdgeInsets.top + expandClickEdgeInsets.bottom)
        return biggerFrame.contains(point)
    }
}
