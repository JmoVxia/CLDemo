//
//  CLTitleCellItem.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/6/22.
//

import UIKit

class CLTitleCellItem: NSObject {
    private(set) var title: String = ""
    private(set) var type: CLController.Type!
    var accessoryType: UITableViewCell.AccessoryType = .none
    var didSelectCellCallback: ((IndexPath) -> Void)?
    init(title: String, type: CLController.Type) {
        self.title = title
        self.type = type
    }
}

extension CLTitleCellItem: CLRowItemProtocol {
    func cellClass() -> UITableViewCell.Type {
        CLTitleCell.self
    }

    func cellHeight() -> CGFloat {
        UIFont.mediumPingFangSC(18).lineHeight + 30
    }
}
