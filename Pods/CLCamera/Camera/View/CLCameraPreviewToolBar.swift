//
//  CLCameraPreviewToolBar.swift
//  CLCamera
//
//  Created by Chen JmoVxia on 2024/2/19.
//

import SnapKit
import UIKit

protocol CLCameraPreviewToolBarDelegate: AnyObject {
    func didTapCancelButton(on toolBar: CLCameraPreviewToolBar)
    func didTapDoneButton(on toolBar: CLCameraPreviewToolBar)
}

// MARK: - JmoVxia---枚举

extension CLCameraPreviewToolBar {}

// MARK: - JmoVxia---类-属性

class CLCameraPreviewToolBar: UIView {
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
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = true
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.insetsLayoutMarginsFromSafeArea = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 30, left: 45, bottom: 30, right: 45)
        stackView.spacing = 0
        return stackView
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("确定", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()

    weak var delegate: CLCameraPreviewToolBarDelegate?
}

// MARK: - JmoVxia---布局

private extension CLCameraPreviewToolBar {
    func setupUI() {
        backgroundColor = .black
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(cancelButton)
        mainStackView.addArrangedSubview(doneButton)
    }

    func makeConstraints() {
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---override

extension CLCameraPreviewToolBar {}

// MARK: - JmoVxia---objc

@objc private extension CLCameraPreviewToolBar {
    func cancelButtonTapped() {
        delegate?.didTapCancelButton(on: self)
    }

    func doneButtonTapped() {
        delegate?.didTapDoneButton(on: self)
    }
}

// MARK: - JmoVxia---私有方法

private extension CLCameraPreviewToolBar {}

// MARK: - JmoVxia---公共方法

extension CLCameraPreviewToolBar {}
