//
//  CLVideoFrameMemoryCache.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 缓存项

private final class CLVideoFrameCacheItem {
    let image: CGImage
    let cost: Int

    init(image: CGImage) {
        self.image = image
        cost = image.bytesPerRow * image.height
    }
}

// MARK: - CLVideoFrameMemoryCache

final class CLVideoFrameMemoryCache {
    private let cache = NSCache<NSString, CLVideoFrameCacheItem>()
    private let lock = NSLock()
    private let config: CLVideoFrameCacheConfig

    private var hitCount = 0
    private var missCount = 0

    init(config: CLVideoFrameCacheConfig) {
        self.config = config
        cache.countLimit = config.memoryMaxCount
        cache.totalCostLimit = config.memoryMaxBytes
    }

    deinit {
        CLLog("CLVideoFrameMemoryCache deinit")
    }
}

// MARK: - 存储与读取

extension CLVideoFrameMemoryCache {
    /// 存储图片
    func storeImage(_ image: CGImage, forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        let item = CLVideoFrameCacheItem(image: image)
        cache.setObject(item, forKey: key as NSString, cost: item.cost)
    }

    /// 读取图片
    func imageForKey(_ key: String) -> CGImage? {
        lock.lock()
        defer { lock.unlock() }
        if let item = cache.object(forKey: key as NSString) {
            hitCount += 1
            return item.image
        }
        missCount += 1
        return nil
    }

    /// 删除指定缓存
    func removeImageForKey(_ key: String) {
        lock.lock()
        defer { lock.unlock() }
        cache.removeObject(forKey: key as NSString)
    }

    /// 清空所有缓存
    func clearMemory() {
        lock.lock()
        defer { lock.unlock() }
        cache.removeAllObjects()
        hitCount = 0
        missCount = 0
        CLVideoFrameCacheLog.log("内存缓存已清空", level: .clean)
    }
}

// MARK: - 统计

extension CLVideoFrameMemoryCache {
    /// 获取命中率
    func getHitRate() -> Double {
        lock.lock()
        defer { lock.unlock() }
        let total = hitCount + missCount
        return total > 0 ? Double(hitCount) / Double(total) : 0.0
    }

    /// 获取统计信息
    func getStatistics() -> (hitCount: Int, missCount: Int, hitRate: Double) {
        lock.lock()
        defer { lock.unlock() }
        let total = hitCount + missCount
        let rate = total > 0 ? Double(hitCount) / Double(total) : 0.0
        return (hitCount, missCount, rate)
    }
}
