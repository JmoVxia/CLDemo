//
//  CKDMedicationItemProtocol.swift
//  CKD
//
//  Created by JmoVxia on 2020/3/26.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

protocol CKDCellItemProtocol {
    ///创建cell
    func dequeueReusableCell(tableView: UITableView) -> UITableViewCell
    ///cell类型
    func tableviewCellClass() -> UITableViewCell.Type
}
extension CKDCellItemProtocol {
    func dequeueReusableCell(tableView: UITableView) -> UITableViewCell {
        let cellClass = tableviewCellClass()
        let identifier = String.init(describing: cellClass)
        var tableViewCell: UITableViewCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            tableViewCell = cell
        }else {
            tableViewCell = cellClass.init(style: .default, reuseIdentifier: identifier)
        }
        if let cell = tableViewCell as? CKDCellProtocol {
            cell.setItem(self)
        }
        return tableViewCell
    }
}
