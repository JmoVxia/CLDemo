//
//  CLCarouselPageControl.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2024/1/12.
//

import Foundation
import UIKit

class CLCarouselPageControl: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.isUserInteractionEnabled = false
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 5
        return view
    }()

    private lazy var currentImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "cutoverH")
        return view
    }()

    var numberOfPages: Int = .zero {
        didSet {
            guard numberOfPages != oldValue else { return }
            reload()
        }
    }

    var currentPage: Int = .zero {
        didSet {
            guard currentPage != oldValue else { return }
            mainStackView.insertArrangedSubview(currentImageView, at: currentPage)
        }
    }
}

private extension CLCarouselPageControl {
    func setupUI() {
        addSubview(mainStackView)
    }

    func makeConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func reload() {
        currentPage = 0
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for _ in 0 ..< max(0, numberOfPages - 1) {
            mainStackView.addArrangedSubview(UIImageView(image: UIImage(named: "cutover")))
        }
        mainStackView.insertArrangedSubview(currentImageView, at: 0)
    }
}
