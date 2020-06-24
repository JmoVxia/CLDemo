//
//  CLChatAlbumContentView.swift
//  CLDemo
//
//  Created by Emma on 2020/2/11.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import Photos

struct CLChatPhotoAlbumSelectedItem {
    let image: UIImage
    let indexPath: IndexPath
    let asset: PHAsset
}

class CLChatPhotoAlbumContentView: UIView {
    ///发送图片回调
    var sendImageCallBack: (([(UIImage, PHAsset)]) -> ())?
    ///关闭回调
    var closeCallback: (() -> ())?
    ///数据源
    private var fetchResult: PHFetchResult<PHAsset>?
    private var selectedArray: [CLChatPhotoAlbumSelectedItem] = [CLChatPhotoAlbumSelectedItem]()
    /// 带缓存的图片管理对象
    private var imageManager: PHCachingImageManager = {
        let manager = PHCachingImageManager()
        manager.stopCachingImagesForAllAssets()
        return manager
    }()
    ///collectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .hexColor(with: "#EEEEED")
        view.register(CLChatPhotoAlbumCell.classForCoder(), forCellWithReuseIdentifier: "CLChatPhotoAlbumCell")
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    ///底部工具条
    private lazy var bottomToolBar: CLChatPhotoAlbumBottomBar = {
        let view = CLChatPhotoAlbumBottomBar()
        view.sendCallback = {[weak self] in
            guard let `self` = self else { return }
            self.sendImageCallBack?(self.selectedArray.map({($0.image, $0.asset)}))
            self.restoreInitialState()
        }
        view.closeCallback = {[weak self] in
            self?.closeCallback?()
        }
        return view
    }()
    ///底部安全区域
    private lazy var bottomSafeView: UIView = {
        let bottomSafeView = UIView()
        bottomSafeView.backgroundColor = .white
        return bottomSafeView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
        initData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatPhotoAlbumContentView {
    private func initUI() {
        addSubview(collectionView)
        addSubview(bottomToolBar)
        addSubview(bottomSafeView)
    }
    private func makeConstraints() {
        bottomSafeView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(cl_safeAreaInsets().bottom)
        }
        bottomToolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalTo(bottomSafeView.snp.top)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomToolBar.snp.top)
        }
    }
    private func initData() {
        DispatchQueue.global().async {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.fetchResult = PHAsset.fetchAssets(with: .image, options: options)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private func calculateSize(with asset: PHAsset?) -> CGSize {
        guard let asset = asset else {
            return .zero
        }
        let scale = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
        let height = frame.height - 44 - 20 - cl_safeAreaInsets().bottom
        return CGSize(width: height * scale, height: height)
    }
}
extension CLChatPhotoAlbumContentView {
    func showImagePicker() {
        guard let imagePicker = TZImagePickerController(maxImagesCount: .max, delegate: nil) else { return }
        imagePicker.allowPickingVideo = false
        imagePicker.allowTakeVideo = false
        imagePicker.allowPickingOriginalPhoto = false
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.didFinishPickingPhotosHandle = {[weak self] (photos, assets, isSelectOriginalPhoto) in
            guard let photos = photos, let assets = assets as? [PHAsset] else {
                return
            }
            self?.restoreInitialState()
            var images = [(UIImage, PHAsset)]()
            for (index, item) in photos.enumerated() {
                images.append((item, assets[index]))
            }
            self?.sendImageCallBack?(images)
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true)
    }
}
extension CLChatPhotoAlbumContentView {
    ///恢复初始状态
    func restoreInitialState() {
        selectedArray.removeAll()
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
        bottomToolBar.seletedNumber = selectedArray.count
    }
}
extension CLChatPhotoAlbumContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var indexPathArray = selectedArray
        if let index = selectedArray.firstIndex(where: {$0.indexPath == indexPath}) {
            selectedArray.remove(at: index)
        }else {
            guard
                let cell = collectionView.cellForItem(at: indexPath) as? CLChatPhotoAlbumCell,
                let image = cell.image,
                let asset = fetchResult?[indexPath.row]
            else {
                return
            }
            let item = CLChatPhotoAlbumSelectedItem(image: image, indexPath: indexPath, asset: asset)
            selectedArray.append(item)
            indexPathArray = selectedArray
        }
        collectionView.reloadItems(at: indexPathArray.map({$0.indexPath}))
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        bottomToolBar.seletedNumber = selectedArray.count
    }
}
extension CLChatPhotoAlbumContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateSize(with: fetchResult?[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
}
extension CLChatPhotoAlbumContentView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLChatPhotoAlbumCell", for: indexPath)
        if let photoAlbumCell = cell as? CLChatPhotoAlbumCell, let asset = fetchResult?[indexPath.row] {
            photoAlbumCell.lockScollViewCallBack = {[weak self](lock) in
                self?.collectionView.isScrollEnabled = lock
            }
            photoAlbumCell.sendImageCallBack = {[weak self] (image) in
                self?.sendImageCallBack?([(image, asset)])
            }
            if let index = selectedArray.firstIndex(where: {$0.indexPath == indexPath}) {
                photoAlbumCell.seletedNumber = index + 1
            }else {
                photoAlbumCell.seletedNumber = 0
            }
            let size = calculateSize(with: asset).applying(CGAffineTransform(scaleX: UIScreen.main.scale, y: UIScreen.main.scale))
            imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { (image, info) in
                DispatchQueue.main.async {
                    photoAlbumCell.image = image
                }
            }
        }
        return cell
    }
}
