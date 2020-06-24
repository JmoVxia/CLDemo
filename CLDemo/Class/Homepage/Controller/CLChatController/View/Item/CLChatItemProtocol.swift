//
//  CLChatItemProtocol.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//


protocol CLChatItemProtocol {
    ///创建cell
      func dequeueReusableCell(tableView: UITableView) -> UITableViewCell
      ///cell类型
      func tableviewCellClass() -> UITableViewCell.Type
}
extension CLChatItemProtocol {
    func dequeueReusableCell(tableView: UITableView) -> UITableViewCell {
        let cellClass = tableviewCellClass()
        let identifier = String.init(describing: cellClass)
        var tableViewCell: UITableViewCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            tableViewCell = cell
        }else {
            tableViewCell = cellClass.init(style: .default, reuseIdentifier: identifier)
        }
        if tableViewCell is CLChatCellProtocol {
            (tableViewCell as! CLChatCellProtocol).setItem(self)
        }
        return tableViewCell
    }
}
