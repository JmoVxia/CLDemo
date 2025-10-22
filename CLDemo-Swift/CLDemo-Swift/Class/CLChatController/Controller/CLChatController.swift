//
//  CLChatController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/23.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import Photos
import UIKit

class CLChatController: CLController {
    /// 图片上传路径
    private let imageUploadPath: String = NSHomeDirectory() + "/Documents" + "/CLChatImageUpload"
    private let tableViewRowManager = CLTableViewRowManager()

    private lazy var tableView: CLIntrinsicTableView = {
        let tableView = CLIntrinsicTableView()
        tableView.dataSource = tableViewRowManager
        tableView.delegate = tableViewRowManager
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        panGestureRecognizer.delegate = self
//        panGestureRecognizer.cancelsTouchesInView = false
//        tableView.addGestureRecognizer(panGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGestureRecognizer)
        return tableView
    }()

    /// 输入工具条
    private lazy var inputToolBar: CLChatInputToolBar = {
        let inputToolBar = CLChatInputToolBar()
        inputToolBar.delegate = self
        inputToolBar.textFont = .mediumPingFangSC(15)
        inputToolBar.placeholder = "请输入文字..."
        return inputToolBar
    }()
}

extension CLChatController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        addTipsMessages(["欢迎来到本Demo"])
    }
}

extension CLChatController {
    private func initUI() {
        view.backgroundColor = .init("#EEEEED")
        view.addSubview(tableView)
        view.addSubview(inputToolBar)
    }

    private func makeConstraints() {
        inputToolBar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.bottom.equalTo(inputToolBar.snp.top)
            make.height.equalToSuperview().offset(-(navigationController?.navigationBar.frame.height ?? 0.0) - statusBarHeight - inputToolBar.toolBarDefaultHeight)
        }
    }

    private func reloadData() {
        tableView.reloadData()
        if tableViewRowManager.dataSource.count >= 1 {
            let item = max(tableViewRowManager.dataSource.count - 1, 0)
            tableView.scrollToRow(at: IndexPath(item: item, section: 0), at: .bottom, animated: true)
        }
    }
}

extension CLChatController {
    private func addTipsMessages(_ messages: [String]) {
        for text in messages {
            let item = CLChatTipsItem()
            item.text = text
            tableViewRowManager.dataSource.append(item)
        }
        reloadData()
    }

    private func addTextMessages(_ messages: [String]) {
        for text in messages {
            let rightItem = CLChatTextItem()
            rightItem.isFromMyself = true
            rightItem.text = text
            tableViewRowManager.dataSource.append(rightItem)

            let leftItem = CLChatTextItem()
            leftItem.isFromMyself = false
            leftItem.text = text
            tableViewRowManager.dataSource.append(leftItem)
        }
        reloadData()
    }

    private func addImageMessages(_ messages: [(image: UIImage, asset: PHAsset)]) {
        for imageInfo in messages {
            guard let previewImageData = imageInfo.image.pngData() else {
                continue
            }
            let rightItem = CLChatImageItem()
            rightItem.imagePath = saveUploadImage(imageData: previewImageData, messageId: rightItem.messageId + "previewImage")
            rightItem.imageOriginalSize = CGSize(width: imageInfo.asset.pixelWidth, height: imageInfo.asset.pixelHeight)
            rightItem.isFromMyself = true
            tableViewRowManager.dataSource.append(rightItem)

            let leftItem = CLChatImageItem()
            leftItem.imagePath = saveUploadImage(imageData: previewImageData, messageId: leftItem.messageId + "previewImage")
            leftItem.imageOriginalSize = CGSize(width: imageInfo.asset.pixelWidth, height: imageInfo.asset.pixelHeight)
            leftItem.isFromMyself = false
            tableViewRowManager.dataSource.append(leftItem)
        }
        reloadData()
    }

    private func addVoiceMessages(duration: TimeInterval, path: String) {
        do {
            let item = CLChatVoiceItem()
            item.duration = duration
            item.path = path
            tableViewRowManager.dataSource.append(item)
        }
        do {
            let item = CLChatVoiceItem()
            item.isFromMyself = false
            item.duration = duration
            item.path = path
            tableViewRowManager.dataSource.append(item)
        }
        reloadData()
    }
}

extension CLChatController {
    func saveUploadImage(imageData: Data, messageId: String) -> String? {
        let path = imageUploadPath + "/\(messageId)"
        if !FileManager.default.fileExists(atPath: imageUploadPath) {
            try? FileManager.default.createDirectory(atPath: imageUploadPath, withIntermediateDirectories: true, attributes: nil)
        }
        if (imageData as NSData).write(toFile: path, atomically: true) {
            return path
        }
        return nil
    }
}

extension CLChatController {
    @objc func dismissKeyboard() {
        inputToolBar.dismissKeyboard()
    }
}

extension CLChatController: CLChatInputToolBarDelegate {
    func inputBarWillSendText(text: String) {
        addTextMessages([text])
    }

    func inputBarWillSendImage(images: [(image: UIImage, asset: PHAsset)]) {
        addImageMessages(images)
    }

    func inputBarFinishRecord(duration: TimeInterval, file: Data) {
        addVoiceMessages(duration: duration, path: "")
    }
}

extension CLChatController {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view, !(touchView is UIButton) else {
            return false
        }
        if inputToolBar.bounds.contains(touch.location(in: inputToolBar)) {
            return false
        }
        return super.gestureRecognizer(gestureRecognizer, shouldReceive: touch)
    }
}
