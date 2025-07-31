//
//  CLActivityButton.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/12/1.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---枚举

extension CLActivityButton {}

// MARK: - JmoVxia---类-属性

class CLActivityButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    private lazy var activityIndicator: UIActivityIndicatorView = { [unowned self] in
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        return activityIndicator
    }()

    private var title: String?

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)
            } else {
                backgroundColor = UIColor(white: 189 / 255, alpha: 1)
            }
        }
    }
}

// MARK: - JmoVxia---布局

private extension CLActivityButton {
    func initUI() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }

    func makeConstraints() {}
}

// MARK: - JmoVxia---数据

private extension CLActivityButton {
    func initData() {}
}

// MARK: - JmoVxia---override

extension CLActivityButton {}

// MARK: - JmoVxia---objc

@objc private extension CLActivityButton {}

// MARK: - JmoVxia---私有方法

private extension CLActivityButton {}

// MARK: - JmoVxia---公共方法

extension CLActivityButton {
    func startAnimating() {
        title = titleLabel?.text
        setTitle(nil, for: .normal)
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
        setTitle(title, for: .normal)
    }
}
