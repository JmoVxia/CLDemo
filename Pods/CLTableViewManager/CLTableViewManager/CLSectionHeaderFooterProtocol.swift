//
//  CLSectionHeaderFooterProtocol.swift
//  CLTableViewManger
//
//  Created by JmoVxia on 2025/10/16.
//

import UIKit

private var itemKey: UInt8 = 0

public protocol CLSectionHeaderFooterBaseProtocol {
    func set(item: CLSectionItemProtocol, section: Int)
}

public protocol CLSectionHeaderFooterProtocol: CLSectionHeaderFooterBaseProtocol where Self: UITableViewHeaderFooterView {
    associatedtype T: CLSectionItemProtocol
    var item: T? { get set }
    func setItem(_ item: T, section: Int)
}

public extension CLSectionHeaderFooterProtocol {
    var item: T? {
           get {
               return objc_getAssociatedObject(self, &itemKey) as? T
           }
           set {
               objc_setAssociatedObject(self, &itemKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
       }
}

public extension CLSectionHeaderFooterProtocol {
    func set(item: CLSectionItemProtocol, section: Int) {
        guard let item = item as? Self.T else { return }
        self.item = item
        setItem(item, section: section)
    }
}
