//
//  CLChatPhotoView.swift
//  Potato
//
//  Created by AUG on 2019/11/23.
//

import UIKit
import SnapKit
import Photos

class CLChatPhotoView: UIView {
    ///发送图片回调
    var sendImageCallBack: (([(UIImage, PHAsset)]) -> ())?
    ///控件宽度
    private var width: CGFloat {
        return cl_screenWidth()
    }
    ///控件高度
    private (set) var height: CGFloat {
        set {
            
        }
        get {
            return 250 + cl_safeAreaInsets().bottom
        }
    }
    ///相册按钮
    private lazy var albumButton: CLChatPhotoCellButton = {
        let albumButton = CLChatPhotoCellButton()
        albumButton.icon = UIImage.init(named: "picIcon")
        albumButton.text = "照片"
        albumButton.addTarget(self, action: #selector(albumButtonAction), for: .touchUpInside)
        return albumButton
    }()
    ///相机按钮
    private lazy var cameraButton: CLChatPhotoCellButton = {
        let cameraButton = CLChatPhotoCellButton()
        cameraButton.icon = UIImage.init(named: "takingPicIcon")
        cameraButton.text = "拍照"
        cameraButton.addTarget(self, action: #selector(cameraButtonButtonAction), for: .touchUpInside)
        return cameraButton
    }()
    ///快速相册
    private lazy var albumContentView: CLChatPhotoAlbumContentView = {
        let view = CLChatPhotoAlbumContentView()
        view.closeCallback = {[weak self] in
            self?.hiddenAlbumContentView()
        }
        view.sendImageCallBack = {[weak self] (images) in
            self?.sendImageCallBack?(images)
        }
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatPhotoView {
    private func initUI() {
        addSubview(albumButton)
        addSubview(cameraButton)
    }
    private func makeConstraints() {
        albumButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(20)
        }
        cameraButton.snp.makeConstraints { (make) in
            make.left.equalTo(albumButton.snp.right).offset(20)
            make.top.equalTo(20)
        }
    }
}
extension CLChatPhotoView {
    func showAlbumContentView() {
        addSubview(albumContentView)
        albumContentView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(height)
            make.top.equalTo(height)
        }
        setNeedsLayout()
        layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.albumContentView.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(self.height)
                make.top.equalTo(0)
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    func hiddenAlbumContentView() {
        addSubview(albumContentView)
        UIView.animate(withDuration: 0.25, animations: {
            self.albumContentView.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(self.height)
                make.top.equalTo(self.height)
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }) { (_) in
            self.albumContentView.restoreInitialState()
        }
    }
}
extension CLChatPhotoView {
    @objc private func albumButtonAction() {
        CLPermissions.request(.photoLibrary) {[weak self] (status) in
            if status.isNoSupport {
                CLLog("当前设备不支持")
            }else if status.isAuthorized {
                self?.showAlbumContentView()
            }else {
                CLLog("没有相册权限 状态 \(status)")
            }
        }
    }
    @objc private func cameraButtonButtonAction() {
        CLPermissions.request(.camera) {(status) in
            if status.isNoSupport {
                CLLog("当前设备不支持")
                
            }else if status.isAuthorized {
                showCameraPicker()
            }else {
                CLLog("没有相机权限 状态 \(status)")
            }
        }
        func showCameraPicker() {
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = false
            cameraPicker.sourceType = .camera
            UIApplication.shared.keyWindow?.rootViewController?.present(cameraPicker, animated: true)
        }
    }
}
extension CLChatPhotoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[.originalImage] as? UIImage)?.fixOrientation() {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            var localIdentifier: String = ""
            PHPhotoLibrary.shared().performChanges({
                guard let assetId = PHAssetChangeRequest.creationRequestForAsset(from: image).placeholderForCreatedAsset?.localIdentifier else { return }
                localIdentifier = assetId
            }) {[weak self] (success, error) in
                let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: options)
                if let asset = assets.firstObject {
                    self?.sendImageCallBack?([(image, asset)])
                }
            }
        }
        picker.dismiss(animated: true)
    }
}
