//
//  CLChatPhotoAlbumImageCache.swift
//  CL
//
//  Created by Chen JmoVxia on 2020/10/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import Photos

class CLChatPhotoAlbumImageCache: NSObject {
    class CLChatPhotoAlbumImageItem: NSObject {
        private (set) var key: String!
        private (set) var image: UIImage!
        init(key: String, image: UIImage) {
            self.key = key
            self.image = image
            super.init()
        }
    }
    private var imageManager: PHCachingImageManager = {
        let manager = PHCachingImageManager()
        return manager
    }()
    private lazy var cachedImages: NSCache<NSString, CLChatPhotoAlbumImageItem> = {
        let cache = NSCache<NSString, CLChatPhotoAlbumImageItem>()
        cache.delegate = self
        return cache
    }()
    private var loadingResponses = [String : [(UIImage) -> Void]]()
}
extension CLChatPhotoAlbumImageCache {
    private func image(identifier: String) -> UIImage? {
        return cachedImages.object(forKey: identifier as NSString)?.image
    }
}
extension CLChatPhotoAlbumImageCache {
    
    /// 加载图片
    /// - Parameters:
    ///   - asset: 相册资源
    ///   - size: 大小
    ///   - completion: 加载完成回调
    func load(asset: PHAsset, size: CGSize, completion: @escaping (UIImage) -> Void) {
        let key = "identifier:\(asset.localIdentifier)+width:\(size.width)+height:\(size.height)".md5()
        if let cachedImage = image(identifier: key) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        if loadingResponses[key] != nil {
            loadingResponses[key]?.append(completion)
            return
        } else {
            loadingResponses[key] = [completion]
        }
        let options = PHImageRequestOptions()
        options.version = .current
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.resizeMode = .none
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) {[weak self] (image, info) in
            guard let image = image,
                  let self = self,
                  let blocks = self.loadingResponses[key]
            else {
                return
            }
            self.cachedImages.setObject(CLChatPhotoAlbumImageItem(key: key, image: image), forKey: key as NSString)
            for block in blocks {
                DispatchQueue.main.async {
                    block(image)
                }
                return
            }
        }
    }
}
extension CLChatPhotoAlbumImageCache: NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let item = obj as? CLChatPhotoAlbumImageItem {
            loadingResponses.removeValue(forKey: item.key)
        }
    }
}
