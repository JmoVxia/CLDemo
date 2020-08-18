//
//  CLDebugCell.swift
//  CL
//
//  Created by JmoVxia on 2020/6/11.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLDebugCell: UITableViewCell {
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        return view
    }()
    private lazy var iconButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "drugMcho"), for: .normal)
        view.setImage(UIImage(named: "drugMchoH"), for: .selected)
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = UIColor.hexColor(with: "#333333")
        view.font = PingFangSCMedium(16)
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLDebugCell {
    private func initUI() {
        isExclusiveTouch = true
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(iconButton)
        contentBackgroundView.addSubview(titleLabel)
    }
    private func makeConstraints() {
        contentBackgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(7.5)
            make.bottom.equalTo(-7.5)
        }
        iconButton.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.size.equalTo(13)
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(iconButton.snp.right).offset(8.5)
            make.top.equalTo(17)
            make.bottom.equalTo(-17)
            make.right.equalTo(-32)
        }
    }
}
extension CLDebugCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentBackgroundView.layer.cornerRadius = contentBackgroundView.bounds.height * 0.5
    }
}
extension CLDebugCell: CLChatCellProtocol {
    func setItem(_ item: CLChatItemProtocol) {
        guard let item = item as? CLDebugItem else {
            return
        }
        iconButton.isSelected = item.isSelected
        titleLabel.text = item.path.lastPathComponent
        titleLabel.textColor = item.isSelected ? .red : .hexColor(with: "#333333")
//        titleLabel.setLineSpacing(10)
        titleLabel.sizeToFit()
        contentBackgroundView.layer.borderColor = item.isSelected ? UIColor.red.cgColor : UIColor.hexColor(with: "#F7F7F7").cgColor
        contentBackgroundView.backgroundColor = item.isSelected ? .white : .hexColor(with: "#F7F7F7")
    }
}
