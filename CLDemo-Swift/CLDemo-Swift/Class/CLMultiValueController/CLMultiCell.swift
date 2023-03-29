//
//  CLMultiCell.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/3/31.
//

import UIKit

//MARK: - JmoVxia---类-属性
class CLMultiCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .init(top: 0, left: 15, bottom: 24, right: 15)
        view.spacing = 5
        return view
    }()
    private(set) lazy var titleButton: UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = false
        view.setTitleColor("#6B6F6A".uiColor, for: .normal)
        view.setTitleColor("#02AA5D".uiColor, for: .selected)
        view.titleLabel?.font = .mediumPingFangSC(16)
        view.contentHorizontalAlignment = .left
        return view
    }()
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.image = .init(named: "selectIcon")
        return view
    }()


}
//MARK: - JmoVxia---布局
private extension CLMultiCell {
    func initSubViews() {
        selectionStyle = .none
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleButton)
        mainStackView.addArrangedSubview(iconImageView)
    }
    func makeConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
//MARK: - JmoVxia---override
extension CLMultiCell {
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        titleButton.isSelected = selected
        iconImageView.isHidden = !selected
    }
}
//MARK: - JmoVxia---objc
@objc private extension CLMultiCell {
}
//MARK: - JmoVxia---私有方法
private extension CLMultiCell {
}
//MARK: - JmoVxia---公共方法
extension CLMultiCell {
}
