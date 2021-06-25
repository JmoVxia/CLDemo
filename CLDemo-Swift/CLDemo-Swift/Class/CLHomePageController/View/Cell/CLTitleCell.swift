//
//  CLTitleCell.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/6/22.
//

import UIKit

//MARK: - JmoVxia---类-属性
class CLTitleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - JmoVxia---布局
private extension CLTitleCell {
    func initUI() {
        textLabel?.font = PingFangSCMedium(18)
        selectionStyle = .none
    }
    func makeConstraints() {
    }
}
extension CLTitleCell: CLCellProtocol {
    func setItem(_ item: CLCellItemProtocol) {
        guard let item = item as? CLTitleCellItem else { return }
        textLabel?.text = item.title
        accessoryType = item.accessoryType
    }
}
