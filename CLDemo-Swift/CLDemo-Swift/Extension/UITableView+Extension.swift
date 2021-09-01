//
//  UITableView+Extension.swift
//  CL
//
//  Created by Chen JmoVxia on 2020/7/29.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let section = numberOfSections
        if section > 0 {
            let row = numberOfRows(inSection: section - 1)
            if row > 0 {
                scrollToRow(at: IndexPath(row: row - 1, section: section - 1), at: .bottom, animated: animated)
            }
        }
    }
}
