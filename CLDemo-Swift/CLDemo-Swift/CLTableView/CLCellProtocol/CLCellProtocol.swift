//
//  CLCellProtocol.swift
//  CL
//
//  Created by JmoVxia on 2020/3/26.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit



protocol CLCellBaseProtocol {
    func setCellItem(_ item: CLCellItemProtocol, indexPath: IndexPath)
}

protocol CLCellProtocol: CLCellBaseProtocol where Self: UITableViewCell {
    associatedtype T: CLCellItemProtocol

    var item: T? { set get }
    
    func setItem(_ item: T, indexPath: IndexPath)
}
extension CLCellProtocol {
    var item: T? {
        set {
        }
        get {
            return nil
        }
    }
    func setCellItem(_ item: CLCellItemProtocol, indexPath: IndexPath) {
        guard let item = item as? Self.T else { return }
        self.item = item
        setItem(item, indexPath: indexPath)
    }
}
