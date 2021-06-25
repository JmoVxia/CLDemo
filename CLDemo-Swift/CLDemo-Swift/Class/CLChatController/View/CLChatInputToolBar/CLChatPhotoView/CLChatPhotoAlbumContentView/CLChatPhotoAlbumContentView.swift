//
//  CLChatAlbumContentView.swift
//  CLDemo
//
//  Created by Emma on 2020/2/11.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import Photos
import TZImagePickerController

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
    ///图片缓存
    private let imageCache = CLChatPhotoAlbumImageCache()
    ///数据源
    private var fetchResult: PHFetchResult<PHAsset>?
    private var selectedArray: [CLChatPhotoAlbumSelectedItem] = [CLChatPhotoAlbumSelectedItem]()
    /// 带缓存的图片管理对象
    private var imageManager: PHCachingImageManager = {
        let manager = PHCachingImageManager()
        manager.allowsCachingHighQualityImages = false
        return manager
    }()
    ///collectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .hex("#EEEEED")
        view.register(CLChatPhotoAlbumCell.classForCoder(), forCellWithReuseIdentifier: "CLChatPhotoAlbumCell")
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    ///相册按钮
    private lazy var albumButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "album"), for: .normal)
        view.setImage(UIImage(named: "album"), for: .selected)
        view.setImage(UIImage(named: "album"), for: .highlighted)
        view.addTarget(self, action: #selector(showAlbum), for: .touchUpInside)
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
        PHPhotoLibrary.shared().register(self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}
private extension CLChatPhotoAlbumContentView {
    func initUI() {
        addSubview(collectionView)
        addSubview(albumButton)
        addSubview(bottomToolBar)
        addSubview(bottomSafeView)
    }
    func makeConstraints() {
        bottomSafeView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(safeAreaEdgeInsets.bottom)
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
        albumButton.snp.makeConstraints { (make) in
            make.size.equalTo(30)
            make.bottom.right.equalTo(collectionView).offset(-15)
        }
    }
    func initData() {
        DispatchQueue.global().async {
            let options = PHFetchOptions()
            options.fetchLimit = 50
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            options.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)
            self.fetchResult = PHAsset.fetchAssets(with: .image, options: options)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
private extension CLChatPhotoAlbumContentView {
    @objc func showAlbum() {
        guard let imagePicker = TZImagePickerController(maxImagesCount: 9, delegate: nil) else { return }
        imagePicker.allowPickingVideo = false
        imagePicker.allowTakeVideo = false
        imagePicker.allowPickingGif = false
        imagePicker.allowPickingOriginalPhoto = false
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.didFinishPickingPhotosHandle = { (photos, assets, _) in
            guard let photos = photos, let assets = assets as? [PHAsset], photos.count == assets.count else {
                return
            }
            var dataArray = [(UIImage, PHAsset)]()
            for (index, item) in photos.enumerated() {
                dataArray.append((item, assets[index]))
            }
            self.sendImageCallBack?(dataArray)
            self.restoreInitialState()
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true)
    }
    /// 刷新可见cell
    func updateVisibleCells() {
        for cell in collectionView.visibleCells {
            guard let cell = cell as? CLChatPhotoAlbumCell, let indexPath = collectionView.indexPath(for: cell) else {
                return
            }
            cell.seletedNumber = currentSeletedNumber(indexPath)
        }
    }
    /// 更新可见celll选中按钮偏移
    func updateVisibleCellsSeletedNumberOffset() {
        for cell in collectionView.visibleCells.compactMap({$0 as? CLChatPhotoAlbumCell}) {
            cell.updateSeletedNumberOffset()
        }
    }
    ///计算显示大小
    func calculateSize(with asset: PHAsset?) -> CGSize {
        guard let asset = asset else {
            return .zero
        }
        let scale = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
        let height = frame.height - 44 - 20 - safeAreaEdgeInsets.bottom
        let width = min(max(120, height * scale), screenWidth * 0.6)
        return CGSize(width: width, height: height)
    }
    ///当前选中数字
    func currentSeletedNumber(_ indexPath: IndexPath) -> Int {
        return (selectedArray.firstIndex(where: {$0.indexPath == indexPath}) ?? -1) + 1
    }
    ///配置cell
    func configureCell(_ cell: CLChatPhotoAlbumCell, with asset: PHAsset) {
        cell.lockScollViewCallBack = {[weak self](lock) in
            self?.collectionView.isScrollEnabled = lock
        }
        cell.sendImageCallBack = {[weak self] (image) in
            self?.sendImageCallBack?([(image, asset)])
        }
        imageCache.load(asset: asset, size: cell.bounds.size) {(image) in
            cell.image = image
        }
    }
}
extension CLChatPhotoAlbumContentView: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let fetchResult = self.fetchResult, let collectionChanges = changeInstance.changeDetails(for: fetchResult) else {
            return
        }
        var array: [String] = [String]()
        fetchResult.enumerateObjects { (asset, _, _) in
            array.append(asset.localIdentifier)
        }
        var changesArray: [String] = [String]()
        collectionChanges.fetchResultAfterChanges.enumerateObjects { (asset, _, _) in
            changesArray.append(asset.localIdentifier)
        }
        DispatchQueue.main.async {
            self.fetchResult = collectionChanges.fetchResultAfterChanges
            self.restoreInitialState()
        }
    }
}
extension CLChatPhotoAlbumContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
            if selectedArray.count >= 9 {
                CLPopupManager.showTips(text: "您一次最多可以选择9张图片")
                return
            }
            let item = CLChatPhotoAlbumSelectedItem(image: image, indexPath: indexPath, asset: asset)
            selectedArray.append(item)
        }
        updateVisibleCells()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        bottomToolBar.seletedNumber = selectedArray.count
    }
}
extension CLChatPhotoAlbumContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateSize(with: fetchResult?[indexPath.row])
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateVisibleCellsSeletedNumberOffset()
    }
}
extension CLChatPhotoAlbumContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLChatPhotoAlbumCell", for: indexPath)
        cell.isExclusiveTouch = false
        if let photoAlbumCell = cell as? CLChatPhotoAlbumCell, let asset = fetchResult?[indexPath.row] {
            configureCell(photoAlbumCell, with: asset)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let photoAlbumCell = cell as? CLChatPhotoAlbumCell {
            photoAlbumCell.seletedNumber = currentSeletedNumber(indexPath)
        }
    }
}
extension CLChatPhotoAlbumContentView {
    ///恢复初始状态
    func restoreInitialState() {
        selectedArray.removeAll()
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: true)
        bottomToolBar.seletedNumber = selectedArray.count
        updateVisibleCellsSeletedNumberOffset()
    }
}
