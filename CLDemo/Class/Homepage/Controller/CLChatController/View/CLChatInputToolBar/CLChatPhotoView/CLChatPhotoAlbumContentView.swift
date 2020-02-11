//
//  CLChatAlbumContentView.swift
//  CLDemo
//
//  Created by Emma on 2020/2/11.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import Photos

class CLChatPhotoAlbumContentView: UIView {
    ///数据源
    private var fetchResult: PHFetchResult<PHAsset>?
    /// 带缓存的图片管理对象
    private var imageManager: PHCachingImageManager = {
        let imageManager = PHCachingImageManager()
        imageManager.stopCachingImagesForAllAssets()
        return imageManager
    }()
    ///顶部工具条
    private lazy var topToolBar: UIView = {
        let topToolBar = UIView()
        return topToolBar
    }()
    ///collectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CLChatPhotoAlbumCell.classForCoder(), forCellWithReuseIdentifier: "CLChatPhotoAlbumCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    ///底部工具条
    private lazy var bottomToolBar: UIView = {
        let bottomToolBar = UIView()
        return bottomToolBar
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
        backgroundColor = hexColor("0x31313F")
        addSubview(topToolBar)
        addSubview(collectionView)
        addSubview(bottomToolBar)
    }
    private func makeConstraints() {
        topToolBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        bottomToolBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topToolBar.snp.bottom)
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
        let height = frame.height - 88
        return CGSize(width: height * scale, height: height)
    }
}
extension CLChatPhotoAlbumContentView {
    ///划到最左边
    func scrollToLeft(animated: Bool = true) {
        collectionView.setContentOffset(.zero, animated: animated)
    }
}
extension CLChatPhotoAlbumContentView: UICollectionViewDelegate {
}
extension CLChatPhotoAlbumContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateSize(with: fetchResult?[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
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
        if let photoAlbumCell = cell as? CLChatPhotoAlbumCell {
            photoAlbumCell.lockScollViewCallBack = {[weak self](lock) in
                self?.collectionView.isScrollEnabled = lock
            }
            if let asset = fetchResult?[indexPath.row] {
                let size = calculateSize(with: asset).applying(CGAffineTransform(scaleX: UIScreen.main.scale, y: UIScreen.main.scale))
                imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { (image, info) in
                    photoAlbumCell.image = image
                }
            }
        }
        return cell
    }
}
