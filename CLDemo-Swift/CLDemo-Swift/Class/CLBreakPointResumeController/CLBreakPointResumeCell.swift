//
//  CLBreakPointResumeCell.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/6/10.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

// MARK: - JmoVxia---类-属性

class CLBreakPointResumeCell: UITableViewCell {
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .mediumPingFangSC(16)
        view.textColor = .black
        view.textAlignment = .left
        return view
    }()

    private lazy var progressLabel: UILabel = {
        let view = UILabel()
        view.font = .mediumPingFangSC(12)
        view.textColor = .orange
        view.textAlignment = .left
        return view
    }()

    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        return view
    }()

    private lazy var downloadButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = .mediumPingFangSC(16)
        view.setTitle("下载", for: .normal)
        view.setTitle("下载", for: .selected)
        view.setTitle("下载", for: .highlighted)
        view.setTitleColor(.black, for: .normal)
        view.setTitleColor(.black, for: .selected)
        view.setTitleColor(.black, for: .highlighted)
        view.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = .mediumPingFangSC(16)
        view.setTitle("取消", for: .normal)
        view.setTitle("取消", for: .selected)
        view.setTitle("取消", for: .highlighted)
        view.setTitleColor(.black, for: .normal)
        view.setTitleColor(.black, for: .selected)
        view.setTitleColor(.black, for: .highlighted)
        view.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return view
    }()

    private lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = .mediumPingFangSC(16)
        view.setTitle("删除", for: .normal)
        view.setTitle("删除", for: .selected)
        view.setTitle("删除", for: .highlighted)
        view.setTitleColor(.black, for: .normal)
        view.setTitleColor(.black, for: .selected)
        view.setTitleColor(.black, for: .highlighted)
        view.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var item: CLBreakPointResumeItem?

    override func prepareForReuse() {
        super.prepareForReuse()
        item?.progressChangeCallback = nil
    }
}

// MARK: - JmoVxia---布局

private extension CLBreakPointResumeCell {
    func initUI() {
        selectionStyle = .none
        contentView.layer.borderColor = UIColor.orange.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(nameLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(progressLabel)
        contentView.addSubview(downloadButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(deleteButton)
    }

    func makeConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.left.top.equalTo(15)
            make.height.equalTo(20)
        }
        progressView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        progressLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalTo(downloadButton)
        }
        downloadButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.bottom.equalTo(-15)
            make.right.equalTo(-15)
        }
        cancelButton.snp.makeConstraints { make in
            make.right.equalTo(downloadButton.snp.left).offset(-10)
            make.size.centerY.equalTo(downloadButton)
        }
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(cancelButton.snp.left).offset(-10)
            make.size.centerY.equalTo(downloadButton)
        }
    }
}

@objc extension CLBreakPointResumeCell {
    func downloadAction() {
        guard let item else { return }
        item.downloadCallback?(item.url)
    }

    func cancelAction() {
        guard let item else { return }
        item.cancelCallback?(item.url)
    }

    func deleteAction() {
        guard let item else { return }
        item.deleteCallback?(item.url)
    }
}

extension CLBreakPointResumeCell: CLRowCellProtocol {
    func setItem(_ item: CLBreakPointResumeItem, indexPath: IndexPath) {
        item.progressChangeCallback = { [weak self] value in
            self?.displayProgress(value)
        }
        nameLabel.text = item.url.lastPathComponent
        displayProgress(item.progress)
    }

    func displayProgress(_ progress: CGFloat) {
        progressView.progress = Float(progress)
        progressLabel.text = String(format: "%.2f", progress * 100) + "%"
    }
}
