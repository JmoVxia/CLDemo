//
//  CLChatLayoutTextItem.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit


class CLChatLayoutTextItem: CLChatLayoutItem {
    var text: String?
}
extension CLChatLayoutTextItem: CLChatLayoutItemProtocol {
    func tableviewCellClass() -> UITableViewCell.Type {
        return CLChatLayoutTextCell.self
    }
}
