//
//  CLDebugItem.swift
//  CL
//
//  Created by JmoVxia on 2020/6/11.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLDebugItem: NSObject {
    var isSelected: Bool = false
    var path: String = ""
}
extension CLDebugItem: CLChatItemProtocol {
    func tableviewCellClass() -> UITableViewCell.Type {
        return CLDebugCell.self
    }
}
