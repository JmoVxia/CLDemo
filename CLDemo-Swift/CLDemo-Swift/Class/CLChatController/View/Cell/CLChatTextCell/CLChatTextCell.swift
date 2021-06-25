//
//  CLChatTextCell.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

//
//  CLChatTextCell.swift
//  Potato
//
//  Created by AUG on 2019/10/12.
//

import UIKit

class CLChatTextCell: CLChatCell {
    ///背景气泡
    var bubbleImageView = UIImageView()
    ///文字
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = PingFangSCMedium(15)
        view.numberOfLines = 0
        view.preferredMaxLayoutWidth = 200.autoWidth()
        return view
    }()
    ///左侧气泡
    private lazy var leftBubbleImage: UIImage = {
        var image = UIImage(named: "leftBg")!
        return image
    }()
    ///右侧气泡
    private lazy var rightBubbleImage: UIImage = {
        var image = UIImage(named: "rightBg")!
        return image
    }()
}
extension CLChatTextCell {
    override func initUI() {
        super.initUI()
        contentView.addSubview(bubbleImageView)
        contentView.addSubview(titleLabel)
    }
    override func makeConstraints() {
        super.makeConstraints()
    }
}
extension CLChatTextCell {
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
        bottomContentView.snp.remakeConstraints { (make) in
            make.edges.equalTo(bubbleImageView)
        }
    }
}
extension CLChatTextCell: CLCellProtocol {
    func setItem(_ item: CLCellItemProtocol) {
        guard let textItem = item as? CLChatTextItem else {
            return
        }
        self.item = nil
        self.item = textItem
        titleLabel.textColor = textItem.isFromMyself ? .white : .black
        titleLabel.attributedText = textItem.attributedText
        titleLabel.sizeToFit()
        
        bubbleImageView.image = textItem.isFromMyself ? rightBubbleImage : leftBubbleImage
        remakeConstraints(isFromMyself: textItem.isFromMyself)
    }
}

