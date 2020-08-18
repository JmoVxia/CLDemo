//
//  CLChatItem.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
/// 消息发送状态
enum CLChatMessageSendState {
    ///正在发送
    case sending
    ///发送成功
    case sendSucess
    ///发送失败
    case sendFail
}
/// 消息接收状态
enum CLChatMessageReceiveState {
    ///下载中
    case downloading
    ///下载成功
    case downloadSucess
    ///下载失败
    case downloadFail
}
/// 消息位置
enum CLChatMessagePosition {
    ///右侧
    case right
    ///中间
    case middle
    ///左侧
    case left
}

class CLChatItem: NSObject {
    ///消息发送状态
    var messageSendState: CLChatMessageSendState = .sendSucess
    ///消息接收状态
    var messageReceiveState: CLChatMessageReceiveState = .downloading
    ///本地消息ID
    var messageId: String = dateRandomString
    ///消息位置
    var position: CLChatMessagePosition = .right
    ///indexPath
    var indexPath: IndexPath = IndexPath()
    ///下载进度
    var progress: CGFloat = 0.0
    ///服务器消息ID
    var msgID: Int64 = 0
}

