//
//  CLRowCellProtocol.swift
//  CLTableViewManger
//
//  Created by JmoVxia on 2025/10/16.
//

import UIKit

private var itemKey: UInt8 = 0

public protocol CLRowCellBaseProtocol {
    func set(item: CLRowItemProtocol, indexPath: IndexPath)
}

public protocol CLRowCellProtocol: CLRowCellBaseProtocol where Self: UITableViewCell {
    associatedtype T: CLRowItemProtocol
    var item: T? { get set }
    func setItem(_ item: T, indexPath: IndexPath)
}

public extension CLRowCellProtocol {
    var item: T? {
           get {
               return objc_getAssociatedObject(self, &itemKey) as? T
           }
           set {
               objc_setAssociatedObject(self, &itemKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
       }
}

public extension CLRowCellProtocol {
    func set(item: CLRowItemProtocol, indexPath: IndexPath) {
        guard let item = item as? Self.T else { return }
        self.item = item
        setItem(item, indexPath: indexPath)
    }
}
