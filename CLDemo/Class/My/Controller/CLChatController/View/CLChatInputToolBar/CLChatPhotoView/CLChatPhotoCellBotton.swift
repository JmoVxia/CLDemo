//
//  CLChatPhotoCellBotton.swift
//  Potato
//
//  Created by AUG on 2019/12/26.
//

import UIKit
import SnapKit

class CLChatPhotoCellBotton: UIButton {
    var icon: UIImage? {
        didSet {
            guard let image = icon else {
                return
            }
            iconImageView.image = image.tintedImage(hexColor("#BABAE2"))
        }
    }
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    private var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    private var textLabel: UILabel = {
       let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = hexColor("#BABAE2")
        return textLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(textLabel)
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(27)
            make.top.equalTo(7)
            make.centerX.equalToSuperview()
        }
        textLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
