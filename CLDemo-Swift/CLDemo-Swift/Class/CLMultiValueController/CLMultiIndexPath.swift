//
//  CLMultiIndexPath.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2023/3/25.
//

import UIKit

struct CLMultiIndexPath {
    let indexPath: IndexPath
    let column: Int
}
extension CLMultiIndexPath: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.indexPath == rhs.indexPath && lhs.column == rhs.column
    }

    public static func != (lhs: Self, rhs: Self) -> Bool {
        lhs.indexPath != rhs.indexPath || lhs.column != rhs.column
    }
}
