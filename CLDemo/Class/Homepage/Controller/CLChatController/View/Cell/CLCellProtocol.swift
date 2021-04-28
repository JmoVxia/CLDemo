//
//  CLCellProtocol.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import Foundation

protocol CLCellProtocol {
    ///设置item
    func setItem(_ item: CLCellItemProtocol, tableView: UITableView, indexPath: IndexPath)
}

