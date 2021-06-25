//
//  CLChatEmojiTextCell.swift
//  Potato
//
//  Created by AUG on 2019/10/28.
//

import UIKit

class CLChatEmojiTextCell: UICollectionViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = PingFangSCMedium(200)
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().offset(-10)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatEmojiTextCell: CLChatEmojiCellProtocol {
    func updateItem(item: CLChatEmojiItemProtocol) {
        guard let emojiItem = item as? CLChatEmojTextItem else {
            return
        }
        label.text = emojiItem.emoji
    }
    static func cellReuseIdentifier() -> String {
        return "CLChatEmojiTextCell"
    }
}
