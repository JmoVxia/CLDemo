//
//  CLChatTipsItem.swift
//  Potato
//
//  Created by AUG on 2019/10/12.
//

import UIKit

class CLChatTipsItem: CLChatItem {
    ///文字
    var text:String?
}
extension CLChatTipsItem: CLCellItemProtocol {
    func bindCell() -> UITableViewCell.Type {
        return CLChatTipsCell.self
    }
}
