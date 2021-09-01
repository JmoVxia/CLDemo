//
//  Array+Extension.swift
//  CL
//
//  Created by Chen JmoVxia on 2021/3/2.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
