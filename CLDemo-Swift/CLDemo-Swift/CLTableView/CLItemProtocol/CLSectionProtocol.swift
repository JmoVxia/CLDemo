//
//  CKDSectionProtocol.swift
//  CKDDoctor
//
//  Created by Chen JmoVxia on 2022/6/15.
//

import Foundation

protocol CLSectionBaseProtocol {
    func set(item: CLSectionItemProtocol, section: Int)
}

protocol CLSectionProtocol: CLSectionBaseProtocol where Self: UITableViewHeaderFooterView {
    associatedtype T: CLSectionItemProtocol
    var item: T? { get set }
    func setItem(_ item: T, section: Int)
}

extension CLSectionProtocol {
    var item: T? {
        get {
            return nil
        }
        set {}
    }

    func set(item: CLSectionItemProtocol, section: Int) {
        guard let item = item as? Self.T else { return }
        self.item = item
        setItem(item, section: section)
    }
}
