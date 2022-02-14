//
//  CLHoneycombCustomCell.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/16.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---枚举
extension CLHoneycombCustomCell {
}
//MARK: - JmoVxia---类-属性
class CLHoneycombCustomCell: CLHoneycombCell {
    required init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
        DispatchQueue.main.async {
            self.contentBackgroundView.setupHexagonMask(lineWidth: 0, color: .clear, cornerRadius: 0)
            self.imageView.setupHexagonMask(lineWidth: 10, color: .random, cornerRadius: 0)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .init("#7CB88D")
        return view
    }()
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
}
//MARK: - JmoVxia---布局
private extension CLHoneycombCustomCell {
    func initUI() {
        backgroundColor = .clear
        addSubview(contentBackgroundView)
        addSubview(imageView)
    }
    func makeConstraints() {
        contentBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
//MARK: - JmoVxia---override
extension CLHoneycombCustomCell {
    override func setHighlighted(_ highlighted: Bool) {
        super.setHighlighted(highlighted)
    }
    override func setSelected(_ selected: Bool) {
        super.setSelected(selected)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.imageView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut) {
                self.imageView.transform = .identity
            }
        }
    }
}
//MARK: - JmoVxia---公共方法
extension CLHoneycombCustomCell {
    func animation() {
        imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.imageView.transform = .identity
        }
    }
}

