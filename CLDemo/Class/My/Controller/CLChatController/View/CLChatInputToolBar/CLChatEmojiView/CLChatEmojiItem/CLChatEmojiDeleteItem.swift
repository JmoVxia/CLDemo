//
//  CLChatEmojiDeleteItem.swift
//  Potato
//
//  Created by AUG on 2019/10/30.
//

import UIKit

class CLChatEmojiDeleteItem: CLChatEmojiItem {
    
}
extension CLChatEmojiDeleteItem: CLChatEmojiItemProtocol {
    func reuseIdentifier() -> String {
        return CLChatEmojiDelegateCell.cellReuseIdentifier()
    }
}
