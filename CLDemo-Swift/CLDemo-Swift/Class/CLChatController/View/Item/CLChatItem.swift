//
//  CLChatItem.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
/// 消息发送状态
enum CLChatMessageSendState: String {
    ///正在发送
    case sending
    ///发送成功
    case sendSucess
    ///发送失败
    case sendFail
}

class CLChatItem: NSObject {
    ///名字高度
    var nameHeight: CGFloat {
        return ceil(UIFont.mediumPingFangSC(12).lineHeight)
    }
    ///时间高度
    var timeHeight: CGFloat {
        return ceil(UIFont.mediumPingFangSC(12).lineHeight)
    }
    ///cell高度
    var height: CGFloat?
    ///头像
    var avatarString: String = ""
    ///头像
    var avatarUrl: URL {
        if let url = URL(string: avatarString), url.scheme != nil {
            return url
        }else {
            return URL(fileURLWithPath: avatarString)
        }
    }
    ///名字
    var name: String = "张三"
    ///消息发送状态
    var messageSendState: CLChatMessageSendState = .sendSucess
    ///消息ID
    var messageId: String = dateRandomString + "-APP"
    ///消息是否是自己发送
    var isFromMyself: Bool = true
    ///消息发送时间
    var sendTime: Int64 = milliStamp
    ///消息显示时间
    var messageShowTime: String {
        return messageTimeFormat(sendTime)
    }
    ///是否显示发送时间
    var isShowSendTime: Bool = false
    ///重发callback
    var resendMessageCallback: (() -> ())?
}

