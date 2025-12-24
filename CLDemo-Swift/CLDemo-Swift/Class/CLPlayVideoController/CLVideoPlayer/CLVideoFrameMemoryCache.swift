//
//  CLVideoFrameMemoryCache.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 缓存项包装类

private class CLVideoFrameCacheItem {
    let image: CGImage
    let cost: Int
    let createTime: Date

    init(image: CGImage) {
        self.image = image
        cost = image.bytesPerRow * image.height
        createTime = Date()
    }
}

// MARK: - 内存缓存

class CLVideoFrameMemoryCache {
    private let cache = NSCache<NSString, CLVideoFrameCacheItem>()
    private let lock = NSLock()
    private let config: CLVideoFrameCacheConfig

    // 统计数据
    private var hitCount: Int = 0
    private var missCount: Int = 0

    init(config: CLVideoFrameCacheConfig) {
        self.config = config
        setupCache()
        CLVideoFrameCacheLog.log("内存缓存初始化完成", level: .info)
    }

    private func setupCache() {
        cache.countLimit = config.memoryMaxCount
        cache.totalCostLimit = config.memoryMaxBytes
    }

    // 存储图片
    func storeImage(_ image: CGImage, forKey key: String) {
        lock.lock()
        defer { lock.unlock() }

        let item = CLVideoFrameCacheItem(image: image)
        cache.setObject(item, forKey: key as NSString, cost: item.cost)

        CLVideoFrameCacheLog.log("内存缓存写入: \(key), 大小: \(item.cost / 1024)KB", level: .write)
    }

    // 读取图片
    func imageForKey(_ key: String) -> CGImage? {
        lock.lock()
        defer { lock.unlock() }

        if let item = cache.object(forKey: key as NSString) {
            hitCount += 1
            CLVideoFrameCacheLog.log("内存缓存命中: \(key)", level: .hit)
            return item.image
        } else {
            missCount += 1
            CLVideoFrameCacheLog.log("内存缓存未命中: \(key)", level: .miss)
            return nil
        }
    }

    // 删除指定缓存
    func removeImageForKey(_ key: String) {
        lock.lock()
        defer { lock.unlock() }

        cache.removeObject(forKey: key as NSString)
        CLVideoFrameCacheLog.log("内存缓存删除: \(key)", level: .delete)
    }

    // 清空所有缓存
    func clearMemory() {
        lock.lock()
        defer { lock.unlock() }

        cache.removeAllObjects()
        hitCount = 0
        missCount = 0
        CLVideoFrameCacheLog.log("内存缓存已清空", level: .clean)
    }

    // 获取缓存命中率
    func getHitRate() -> Double {
        lock.lock()
        defer { lock.unlock() }

        let total = hitCount + missCount
        guard total > 0 else { return 0.0 }
        return Double(hitCount) / Double(total)
    }

    // 获取统计信息
    func getStatistics() -> (hitCount: Int, missCount: Int, hitRate: Double) {
        lock.lock()
        defer { lock.unlock() }

        let hitRate = getHitRate()
        return (hitCount, missCount, hitRate)
    }

    // 打印统计信息
    func logStatistics() {
        let stats = getStatistics()
        CLVideoFrameCacheLog.log("内存缓存统计 - 命中:\(stats.hitCount) 未命中:\(stats.missCount) 命中率:\(String(format: "%.2f%%", stats.hitRate * 100))", level: .info)
    }

    deinit {
        CLVideoFrameCacheLog.log("内存缓存释放", level: .info)
    }
}
