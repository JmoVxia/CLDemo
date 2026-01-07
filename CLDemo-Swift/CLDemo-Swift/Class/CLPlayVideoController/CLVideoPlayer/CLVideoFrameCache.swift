//
//  CLVideoFrameCache.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import CryptoKit
import Foundation
import UIKit

// MARK: - CLVideoFrameCache

final class CLVideoFrameCache {
    static let shared = CLVideoFrameCache()

    private let config: CLVideoFrameCacheConfig
    private let memoryCache: CLVideoFrameMemoryCache
    private let diskCache: CLVideoFrameDiskCache

    init(config: CLVideoFrameCacheConfig = .shared) {
        self.config = config
        memoryCache = CLVideoFrameMemoryCache(config: config)
        diskCache = CLVideoFrameDiskCache(config: config)
        diskCache.cleanExpiredDiskCache()
    }

    deinit {
        CLLog("CLVideoFrameCache deinit")
    }
}

// MARK: - 查询

extension CLVideoFrameCache {
    /// 同步查询内存缓存
    func memoryCacheImageForKey(_ key: String) -> CGImage? {
        guard config.cacheMode == .memoryOnly || config.cacheMode == .all else { return nil }
        return memoryCache.imageForKey(key)
    }

    /// 异步查询缓存（内存 → 磁盘）
    func queryImageForKey(_ key: String, completion: @escaping (CGImage?) -> Void) {
        if config.cacheMode == .memoryOnly || config.cacheMode == .all {
            if let image = memoryCache.imageForKey(key) {
                completion(image)
                return
            }
        }

        if config.cacheMode == .diskOnly || config.cacheMode == .all {
            diskCache.imageForKey(key) { image in
                if let image, self.config.cacheMode == .all {
                    self.memoryCache.storeImage(image, forKey: key)
                }
                completion(image)
            }
        } else {
            completion(nil)
        }
    }
}

// MARK: - 存储

extension CLVideoFrameCache {
    /// 存储图片
    func storeImage(_ image: CGImage, forKey key: String, completion: (() -> Void)? = nil) {
        if config.cacheMode == .memoryOnly || config.cacheMode == .all {
            memoryCache.storeImage(image, forKey: key)
        }

        if config.cacheMode == .diskOnly || config.cacheMode == .all {
            diskCache.storeImage(image, forKey: key, completion: completion)
        } else {
            completion?()
        }
    }

    /// 删除指定缓存
    func removeImageForKey(_ key: String) {
        memoryCache.removeImageForKey(key)
        diskCache.removeImageForKey(key)
    }
}

// MARK: - 清理

extension CLVideoFrameCache {
    /// 清空内存缓存
    func clearMemory() {
        memoryCache.clearMemory()
    }

    /// 清空磁盘缓存
    func clearDisk(completion: (() -> Void)? = nil) {
        diskCache.clearDisk(completion: completion)
    }

    /// 清空所有缓存
    func clearAll(completion: (() -> Void)? = nil) {
        memoryCache.clearMemory()
        diskCache.clearDisk(completion: completion)
    }

    /// 获取缓存大小
    func getCacheSize(completion: @escaping (Int, Int) -> Void) {
        diskCache.getDiskCacheSize { diskSize in
            completion(0, diskSize)
        }
    }
}

// MARK: - 工具方法

extension CLVideoFrameCache {
    /// 生成缓存键
    static func cacheKey(videoURL: URL, frameIndex: Int, frameRate: Float = 0) -> String {
        let hash = sha256(videoURL.isFileURL ? ("local://" + videoURL.lastPathComponent) : videoURL.absoluteString)
        return "\(hash)_fps\(Int(frameRate))_\(frameIndex)"
    }

    private static func sha256(_ string: String) -> String {
        let data = Data(string.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
