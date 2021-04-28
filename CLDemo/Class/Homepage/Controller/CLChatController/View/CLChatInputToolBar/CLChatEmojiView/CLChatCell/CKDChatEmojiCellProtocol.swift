//
//  CLChatEmojiCellProtocol.swift
//  Potato
//
//  Created by AUG on 2019/10/30.
//

import Foundation

protocol CLChatEmojiCellProtocol: AnyObject {
    ///cell复用标识符
    static func cellReuseIdentifier() -> String
    ///更新数据
    func updateItem(item: CLChatEmojiItemProtocol)
}
