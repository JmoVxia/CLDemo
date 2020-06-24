//
//  CKDDebugItem.swift
//  CKD
//
//  Created by JmoVxia on 2020/6/11.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CKDDebugItem: NSObject {
    var isSelected: Bool = false
    var path: String = ""
}
extension CKDDebugItem: CLChatItemProtocol {
    func tableviewCellClass() -> UITableViewCell.Type {
        return CKDDebugCell.self
    }
}
