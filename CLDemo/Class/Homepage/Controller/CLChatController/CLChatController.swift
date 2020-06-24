//
//  CLChatController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/23.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit
import Photos

class CLChatController: CLBaseViewController {
    ///图片上传路径
    private let imageUploadPath: String = pathDocuments + "/CLChatImageUpload"
    private var dataSource = [CLChatItemProtocol]()
    private lazy var tableView: CLIntrinsicTableView = {
        let tableView = CLIntrinsicTableView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        panGestureRecognizer.delegate = self
        panGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(panGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGestureRecognizer)
        return tableView
    }()
    ///输入工具条
    private lazy var inputToolBar: CLChatInputToolBar = {
        let inputToolBar = CLChatInputToolBar()
        inputToolBar.delegate = self
        inputToolBar.textFont = UIFont.systemFont(ofSize: 15)
        inputToolBar.placeholder = "请输入文字..."
        return inputToolBar
    }()
}
extension CLChatController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        addTipsMessages(["欢迎来到本Demo"])
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        inputToolBar.viewWillTransition(to: size, with: coordinator)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
extension CLChatController {
    private func initUI() {
        view.backgroundColor = .hexColor(with: "#EEEEED")
        view.addSubview(tableView)
        view.addSubview(inputToolBar)
    }
    private func makeConstraints() {
        inputToolBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(inputToolBar.snp.top)
            make.height.equalToSuperview().offset(-(navigationController?.navigationBar.frame.height ?? 0.0) - cl_statusBarHeight() - inputToolBar.toolBarDefaultHeight)
        }
    }
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.dataSource.count >= 1 {
                let item = max(self.dataSource.count - 1, 0)
                self.tableView.scrollToRow(at: IndexPath(item: item, section: 0), at: .bottom, animated: true)
            }
        }
    }
}
extension CLChatController {
    private func addTipsMessages(_ messages: [String]) {
        DispatchQueue.global().async {
            for text in messages {
                let item = CLChatTipsItem()
                item.text = text
                self.dataSource.append(item)
            }
            self.reloadData()
        }
    }
    private func addTextMessages(_ messages: [String]) {
        DispatchQueue.global().async {
            do {
                for text in messages {
                    let item = CLChatTextItem()
                    item.position = .right
                    item.text = text
                    self.dataSource.append(item)
                }
            }
            do {
                for text in messages {
                    let item = CLChatTextItem()
                    item.position = .left
                    item.text = text
                    self.dataSource.append(item)
                }
            }
            self.reloadData()
        }
    }
    private func addImageMessages(_ messages: [(image: UIImage, asset: PHAsset)]) {
        DispatchQueue.global().async {
            do {
                for imageInfo in messages {
                    guard let previewImageData = imageInfo.image.pngData() else {
                        return
                    }
                    let imageItem = CLChatImageItem.init()
                    imageItem.imagePath = self.saveUploadImage(imageData: previewImageData, messageId: (imageItem.messageId + "previewImage"))
                    imageItem.imageOriginalSize = CGSize(width: imageInfo.asset.pixelWidth, height: imageInfo.asset.pixelHeight)
                    imageItem.position = .right
                    self.dataSource.append(imageItem)
                }
            }
            do {
                for imageInfo in messages {
                    guard let previewImageData = imageInfo.image.pngData() else {
                        return
                    }
                    let imageItem = CLChatImageItem.init()
                    imageItem.imagePath = self.saveUploadImage(imageData: previewImageData, messageId: (imageItem.messageId + "previewImage"))
                    imageItem.imageOriginalSize = CGSize(width: imageInfo.asset.pixelWidth, height: imageInfo.asset.pixelHeight)
                    imageItem.position = .left
                    self.dataSource.append(imageItem)
                }
            }
            self.reloadData()
        }
    }
    private func addVoiceMessages(duration: TimeInterval, path: String) {
        DispatchQueue.global().async {
            do {
                let item = CLChatVoiceItem()
                item.duration = duration
                item.path = path
                self.dataSource.append(item)
            }
            do {
                let item = CLChatVoiceItem()
                item.position = .left
                item.duration = duration
                item.path = path
                self.dataSource.append(item)
            }
            self.reloadData()
        }
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
extension CLChatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        return item.dequeueReusableCell(tableView: tableView)
    }
}
extension CLChatController: CLChatInputToolBarDelegate {
    func inputBarWillSendText(text: String) {
        addTextMessages([text])
    }
    func inputBarWillSendImage(images: [(image: UIImage, asset: PHAsset)]) {
        addImageMessages(images)
    }
    func inputBarFinishRecord(duration: TimeInterval, path: String) {
        print("duration = \(duration), path = \(path)")
        addVoiceMessages(duration: duration, path: path)
    }
}
extension CLChatController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else {
            return false
        }
        let touchFrame = view.convert(touchView.frame, from: touchView.superview)
        if inputToolBar.frame.contains(touchFrame) || !inputToolBar.isShowKeyboard {
            return false
        }
        return true
    }
}
