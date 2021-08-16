//
//  CLHoneycombCollectionViewCell.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/13.
//

import UIKit

class CLHoneycombCollectionViewCell: UICollectionViewCell {
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .hex("#7CB88D")
        return view
    }()
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        initUI()
        makeConstraints()
        DispatchQueue.main.async {
            self.contentBackgroundView.setupHexagonMask(lineWidth: 0, color: .clear, cornerRadius: 0)
            self.imageView.setupHexagonMask(lineWidth: 10, color: .randomColor, cornerRadius: 0)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - JmoVxia---布局
private extension CLHoneycombCollectionViewCell {
    func initUI() {
        backgroundColor = .clear
        contentView.addSubview(contentBackgroundView)
        contentView.addSubview(imageView)
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
extension CLHoneycombCollectionViewCell {
    func animation() {
        imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.imageView.transform = .identity
        }
    }
}
