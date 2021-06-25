//
//  CLChatPhotoCellButton.swift
//  Potato
//
//  Created by AUG on 2019/12/26.
//

import UIKit
import SnapKit

class CLChatPhotoCellButton: UIControl {
    var icon: UIImage? {
        didSet {
            guard let image = icon else {
                return
            }
            iconImageView.image = image
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
        textLabel.font = PingFangSCMedium(14)
        textLabel.textColor = .hex("#666666")
        return textLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(textLabel)
        iconImageView.snp.makeConstraints { (make) in
            make.size.equalTo(57.5)
            make.top.left.right.equalToSuperview()
        }
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
