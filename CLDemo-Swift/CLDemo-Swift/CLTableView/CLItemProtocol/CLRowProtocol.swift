//
//  CLRowProtocol.swift
//  CL
//
//  Created by JmoVxia on 2020/3/26.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

protocol CLCellBaseProtocol {
    func set(item: CLRowItemProtocol, indexPath: IndexPath)
}

protocol CLRowProtocol: CLCellBaseProtocol where Self: UITableViewCell {
    associatedtype T: CLRowItemProtocol
    var item: T? { get set }
    func setItem(_ item: T, indexPath: IndexPath)
}

extension CLRowProtocol {
    var item: T? {
        get {
            nil
        }
        set {}
    }

    func set(item: CLRowItemProtocol, indexPath: IndexPath) {
        guard let item = item as? Self.T else { return }
        self.item = item
        setItem(item, indexPath: indexPath)
    }
}
