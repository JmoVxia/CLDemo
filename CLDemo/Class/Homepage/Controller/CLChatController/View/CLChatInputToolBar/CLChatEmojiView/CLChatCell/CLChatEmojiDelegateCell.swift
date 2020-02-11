//
//  CLChatEmojiDelegateCell.swift
//  Potato
//
//  Created by AUG on 2019/10/30.
//

import UIKit

class CLChatEmojiDelegateCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "knock_emoji_delete")
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatEmojiDelegateCell: CLChatEmojiCellProtocol {
    func updateItem(item: CLChatEmojiItemProtocol) {
        
    }
    static func cellReuseIdentifier() -> String {
        return "CLChatEmojiDelegateCell"
    }
}
