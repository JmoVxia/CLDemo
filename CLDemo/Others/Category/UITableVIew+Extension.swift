//
//  UITableVIew+Extension.swift
//  CLDemo
//
//  Created by JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

extension UITableView {
    func isCellVisible(_ indexPath: IndexPath) -> Bool {
        guard let indexes = self.indexPathsForVisibleRows else {
            return false
        }
        return indexes.contains {$0.section == indexPath.section && $0.row == indexPath.row }
    }
}
