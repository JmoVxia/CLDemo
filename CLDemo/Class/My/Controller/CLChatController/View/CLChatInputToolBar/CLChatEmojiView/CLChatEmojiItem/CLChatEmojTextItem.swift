//
//  CLChatEmojTextItem.swift
//  Potato
//
//  Created by AUG on 2019/10/30.
//

import UIKit

class CLChatEmojTextItem: CLChatEmojiItem {
    ///emoji文字
    var emoji: String?
}

extension CLChatEmojTextItem: CLChatEmojiItemProtocol {
    func reuseIdentifier() -> String {
        return CLChatEmojiTextCell.cellReuseIdentifier()
    }
}
