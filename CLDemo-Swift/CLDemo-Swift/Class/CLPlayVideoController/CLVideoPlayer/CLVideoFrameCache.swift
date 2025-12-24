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

// MARK: - 缓存管理器

class CLVideoFrameCache {
    static let shared = CLVideoFrameCache()

    private let config: CLVideoFrameCacheConfig
    private let memoryCache: CLVideoFrameMemoryCache
    private let diskCache: CLVideoFrameDiskCache

    init(config: CLVideoFrameCacheConfig = .shared) {
        self.config = config
        memoryCache = CLVideoFrameMemoryCache(config: config)
        diskCache = CLVideoFrameDiskCache(config: config)

        CLVideoFrameCacheLog.log("缓存管理器初始化完成", level: .info)

        // 启动时清理过期缓存
        diskCache.cleanExpiredDiskCache()
    }

    // 同步查询内存缓存（快速路径）
    func memoryCacheImageForKey(_ key: String) -> CGImage? {
        if config.cacheMode == .memoryOnly || config.cacheMode == .all {
            return memoryCache.imageForKey(key)
        }
        return nil
    }

    // 查询缓存（内存 → 磁盘链路）
    func queryImageForKey(_ key: String, completion: @escaping (CGImage?) -> Void) {
        CLVideoFrameCacheLog.log("查询缓存: \(key)", level: .read)

        // 首先查询内存缓存
        if config.cacheMode == .memoryOnly || config.cacheMode == .all {
            if let image = memoryCache.imageForKey(key) {
                completion(image)
                return
            }
        }

        // 内存未命中，查询磁盘缓存
        if config.cacheMode == .diskOnly || config.cacheMode == .all {
            diskCache.imageForKey(key) { [weak self] image in
                guard let self else {
                    completion(nil)
                    return
                }

                // 如果磁盘命中，存入内存缓存
                if let image, config.cacheMode == .all {
                    memoryCache.storeImage(image, forKey: key)
                }

                completion(image)
            }
        } else {
            completion(nil)
        }
    }

    // 存储缓存
    func storeImage(_ image: CGImage, forKey key: String, completion: (() -> Void)? = nil) {
        CLVideoFrameCacheLog.log("存储缓存: \(key)", level: .write)

        // 存入内存缓存
        if config.cacheMode == .memoryOnly || config.cacheMode == .all {
            memoryCache.storeImage(image, forKey: key)
        }

        // 存入磁盘缓存
        if config.cacheMode == .diskOnly || config.cacheMode == .all {
            diskCache.storeImage(image, forKey: key, completion: completion)
        } else {
            completion?()
        }
    }

    // 删除指定缓存
    func removeImageForKey(_ key: String) {
        memoryCache.removeImageForKey(key)
        diskCache.removeImageForKey(key)
    }

    // 清空内存缓存
    func clearMemory() {
        memoryCache.clearMemory()
    }

    // 清空磁盘缓存
    func clearDisk(completion: (() -> Void)? = nil) {
        diskCache.clearDisk(completion: completion)
    }

    // 清空所有缓存
    func clearAll(completion: (() -> Void)? = nil) {
        memoryCache.clearMemory()
        diskCache.clearDisk(completion: completion)
    }

    // 获取缓存大小
    func getCacheSize(completion: @escaping (Int, Int) -> Void) {
        diskCache.getDiskCacheSize { diskSize in
            completion(0, diskSize)
        }
    }

    // 获取统计信息
    func getStatistics() {
        memoryCache.logStatistics()
        diskCache.getDiskCacheSize { size in
            CLVideoFrameCacheLog.log("磁盘缓存大小: \(size / 1024 / 1024)MB", level: .info)
        }
    }

    // 生成缓存键
    static func cacheKey(videoURL: URL, frameIndex: Int, frameRate: Float = 0) -> String {
        let sha256 = sha256(videoURL.isFileURL ? ("local://" + videoURL.lastPathComponent) : videoURL.absoluteString)
        let fps = Int(frameRate)
        let key = "\(sha256)_fps\(fps)_\(frameIndex)"
        return key
    }

    // SHA256 哈希
    private static func sha256(_ string: String) -> String {
        let data = Data(string.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    deinit {
        CLVideoFrameCacheLog.log("缓存管理器释放", level: .info)
    }
}
