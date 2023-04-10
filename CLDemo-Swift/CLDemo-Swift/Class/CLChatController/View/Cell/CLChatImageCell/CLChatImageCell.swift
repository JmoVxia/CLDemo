//
//  CLChatImageCell.swift
//  Potato
//
//  Created by AUG on 2019/10/14.
//

import Kingfisher
import UIKit

class CLChatImageCell: CLChatCell {
    /// photoView
    private(set) lazy var photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.image = nil
        photoView.backgroundColor = .init("0x4A4A6A")
        photoView.isUserInteractionEnabled = true
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 6
        photoView.contentMode = .scaleAspectFill
        let tapPhotoView = UITapGestureRecognizer(target: self, action: #selector(tapPhotoViewAction))
        photoView.addGestureRecognizer(tapPhotoView)
        photoView.isExclusiveTouch = true
        return photoView
    }()
    /// 进度
//    private lazy var progressView: CLChatImageProgressView = {
//        let progressView = CLChatImageProgressView.init(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
//        return progressView
//    }()
    /// 下载按钮
//    private lazy var downloadFailButton: UIButton = {
//        let downloadFailButton = UIButton()
    ////        downloadFailButton.setImage(PTImageSVG.knockDownloadIcon, for: .normal)
    ////        downloadFailButton.setImage(PTImageSVG.knockDownloadIcon, for: .selected)
    ////        downloadFailButton.setImage(PTImageSVG.knockDownloadIcon, for: .highlighted)
//        downloadFailButton.addTarget(self, action: #selector(downloadFailButtonAction), for: .touchUpInside)
//        return downloadFailButton
//    }()
}

extension CLChatImageCell {
    /// 创建UI
    override func initUI() {
        super.initUI()
        contentView.addSubview(photoView)
//        contentView.addSubview(progressView)
//        contentView.addSubview(downloadFailButton)
    }

    override func makeConstraints() {
        super.makeConstraints()
//        progressView.snp.makeConstraints { (make) in
//            make.center.equalTo(photoView)
//            make.size.equalTo(45)
//        }
//        downloadFailButton.snp.makeConstraints { (make) in
//            make.center.equalTo(photoView)
//            make.size.equalTo(45)
//        }
    }
}

extension CLChatImageCell: CLRowProtocol {
    func setItem(_ item: CLChatImageItem, indexPath: IndexPath) {
        if let path = item.imagePath {
            photoView.kf.setImage(with: URL(fileURLWithPath: path))
        } else {
            photoView.image = nil
        }
        remakeConstraints(isFromMyself: item.isFromMyself, imageSize: item.size)
    }
}

extension CLChatImageCell {
    private func remakeConstraints(isFromMyself: Bool, imageSize: CGSize) {
        photoView.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10).priority(.high)
            if isFromMyself {
                make.right.equalTo(-10)
            } else {
                make.left.equalTo(10)
            }
            make.size.equalTo(imageSize)
        }
        bottomContentView.snp.remakeConstraints { make in
            make.edges.equalTo(photoView)
        }
    }
}

extension CLChatImageCell {
    private func updateUI(item: CLChatImageItem) {
//        let isFromMyself: Bool = item.position == .right
//        progressView.isHidden = isFromMyself
//        downloadFailButton.isHidden = !(!isFromMyself && item.messageReceiveState == .downloadFail)
//        if !downloadFailButton.isHidden {
//            item.progress = 0.0
//            progressView.updateProgress(value: 0.0)
//            progressView.isHidden = true
//        }else {
//            if !isFromMyself {
//                progressView.updateProgress(value: item.progress)
//            }
//        }
    }
}

extension CLChatImageCell {
    @objc private func tapPhotoViewAction() {
//        guard let imageItem = item as? CLChatImageItem,
//            let path = imageItem.imagePath else {
//                return
//        }
    }
//    @objc private func downloadFailButtonAction() {
//        guard let imageItem = item as? CLChatImageItem  else {return}
//        imageItem.messageReceiveState = .downloading
//        setItem(imageItem)
    ////        presenter?.reTryDownloadImageWithItem(imageItem)
//    }
}
