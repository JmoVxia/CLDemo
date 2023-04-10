//
//  CLHoneycombCell.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/16.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---类-属性

class CLHoneycombCell: UIView {
    required init(reuseIdentifier: String) {
        super.init(frame: .zero)
        identifier = reuseIdentifier
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) var identifier: String!
    private(set) var isSelected: Bool = false
}

@objc extension CLHoneycombCell {
    func setHighlighted(_ highlighted: Bool) {}

    func setSelected(_ selected: Bool) {
        isSelected = selected
    }
}
