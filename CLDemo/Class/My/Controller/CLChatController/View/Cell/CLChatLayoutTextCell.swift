//
//  CLChatLayoutTextCell.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLChatLayoutTextCell: CLChatLayoutCell {
    ///背景气泡
    var bubbleImageView = UIImageView()
    ///文字
    var titleLabel = UILabel.init().then { (label) in
        label.textColor = hexColor("0xffffff")
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 250
    }
    ///左侧气泡
    private lazy var leftBubbleImage: UIImage = {
        var image = UIImage.init(named: "icon_message_l_bg")!
        image = image.resizableImage(withCapInsets: UIEdgeInsets.init(top: image.size.height * 0.5, left: image.size.width * 0.5, bottom: image.size.height * 0.5, right: image.size.width * 0.5))
        return image
    }()
    ///右侧气泡
    private lazy var rightBubbleImage: UIImage = {
        var image = UIImage.init(named: "icon_message_r_bg")!
        image = image.resizableImage(withCapInsets: UIEdgeInsets.init(top: image.size.height * 0.5, left: image.size.width * 0.5, bottom: image.size.height * 0.5, right: image.size.width * 0.5))
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CLChatLayoutTextCell {
    func initUI() {
        contentView.addSubview(bubbleImageView)
        contentView.addSubview(titleLabel)
    }
}
extension CLChatLayoutTextCell {
    private func remakeConstraints(isFromMyself: Bool) {
        bubbleImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10).priority(.high)
            if isFromMyself {
                make.right.equalTo(contentView.snp.right).offset(-10)
            }else {
                make.left.equalTo(contentView.snp.left).offset(10)
            }
        }
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(bubbleImageView.snp.top).offset(5)
            make.bottom.equalTo(bubbleImageView.snp.bottom).offset(-5)
            make.left.equalTo(bubbleImageView.snp.left).offset(isFromMyself ? 10 : 15)
            make.right.equalTo(bubbleImageView.snp.right).offset(isFromMyself ? -15 : -10)
        }
    }
}
extension CLChatLayoutTextCell: CLChatLayoutCellProtocol {
    func setItem(_ item: CLChatLayoutItemProtocol) {
        guard let textItem = item as? CLChatLayoutTextItem else {
            return
        }
        self.item = textItem
        titleLabel.text = textItem.text
        titleLabel.sizeToFit()
        let isFromMyself: Bool = textItem.position == .right
        
        bubbleImageView.image = isFromMyself ? rightBubbleImage : leftBubbleImage
        remakeConstraints(isFromMyself: isFromMyself)
    }
}
