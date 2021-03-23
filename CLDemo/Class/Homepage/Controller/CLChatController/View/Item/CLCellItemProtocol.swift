//
//  CLCellItemProtocol.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//


protocol CLCellItemProtocol {
    ///加载cell
    var cellForRowCallback: ((IndexPath) -> ())? { get set }
    ///将要显示cell
    var willDisplayCallback: ((IndexPath) -> ())? { get set }
    ///点击cell回调
    var didSelectCellCallback: ((IndexPath) -> ())? { get set }
    ///绑定cell
    func bindCell() -> UITableViewCell.Type
    ///创建cell
    func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    ///高度
    func cellHeight() -> CGFloat
}
extension CLCellItemProtocol {
    var cellForRowCallback: ((IndexPath) -> ())? {
        get {
            return nil
        }
        set {
            
        }
    }
    var willDisplayCallback: ((IndexPath) -> ())? {
        get {
            return nil
        }
        set {
            
        }
    }
    var didSelectCellCallback: ((IndexPath) -> ())? {
        get {
            return nil
        }
        set {
            
        }
    }
    func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cellClass = bindCell()
        let identifier = String.init(describing: cellClass)
        var tableViewCell: UITableViewCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            tableViewCell = cell
        }else {
            tableViewCell = cellClass.init(style: .default, reuseIdentifier: identifier)
        }
        if let cell = tableViewCell as? CLCellProtocol {
            cell.setItem(self)
        }
        return tableViewCell
    }
    ///高度
    func cellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
}
