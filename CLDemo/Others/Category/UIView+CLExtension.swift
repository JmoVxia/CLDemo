//
//  UIView+CLExtension.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import Foundation

extension UIView {
    func setFrame(_ frame: CGRect) {
        if self.frame != frame {
            self.frame = frame
        }
    }
}
