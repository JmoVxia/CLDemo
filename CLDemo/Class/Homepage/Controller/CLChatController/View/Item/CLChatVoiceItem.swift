//
//  CLChatVoiceItem.swift
//  Potato
//
//  Created by AUG on 2019/10/14.
//

import UIKit

class CLChatVoiceItem: CLChatItem {
    ///总时长
    var duration: TimeInterval = 0.0
    ///播放状态
    var isPlaying: Bool = false
    ///音频路径
    var path: String = ""
}
extension CLChatVoiceItem: CLCellItemProtocol {
    func bindCell() -> UITableViewCell.Type {
        return CLChatVoiceCell.self
    }
    func cellHeight() -> CGFloat {
        return 60
    }
}
