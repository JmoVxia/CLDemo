//
//  CLChatLayoutItem.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
/// 消息位置
enum MessagePosition {
    ///右侧
    case right
    ///左侧
    case left
}

class CLChatLayoutItem: NSObject {
    ///消息位置
    var position: MessagePosition = .right

}
