//
//  CLVideoFrameDiskCache.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import CryptoKit
import Foundation
import UIKit

// MARK: - 磁盘缓存

class CLVideoFrameDiskCache {
    private let config: CLVideoFrameCacheConfig
    private let ioQueue: DispatchQueue
    private let fileManager = FileManager.default
    private let diskCachePath: String

    init(config: CLVideoFrameCacheConfig) {
        self.config = config
        ioQueue = DispatchQueue(label: "com.clvideo.diskcache", qos: .userInitiated, attributes: [])

        // 创建缓存路径
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        diskCachePath = (cachesPath as NSString).appendingPathComponent("CLVideoFrameCache")

        createCacheDirectoryIfNeeded()
        CLVideoFrameCacheLog.log("磁盘缓存初始化完成, 路径: \(diskCachePath)", level: .info)
    }

    // 创建缓存目录
    private func createCacheDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: diskCachePath) {
            try? fileManager.createDirectory(atPath: diskCachePath, withIntermediateDirectories: true, attributes: nil)
            CLVideoFrameCacheLog.log("创建磁盘缓存目录: \(diskCachePath)", level: .info)
        }
    }

    // 生成文件路径
    private func cacheFilePath(forKey key: String) -> String {
        let fileExtension = switch config.diskImageFormat {
        case .png:
            "png"
        case .jpeg:
            "jpg"
        }
        return (diskCachePath as NSString).appendingPathComponent("\(key).\(fileExtension)")
    }

    // SHA256 哈希
    private func sha256(_ string: String) -> String {
        let data = Data(string.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    // 存储图片到磁盘
    func storeImage(_ image: CGImage, forKey key: String, completion: (() -> Void)? = nil) {
        ioQueue.async { [weak self] in
            guard let self else { return }

            let filePath = cacheFilePath(forKey: key)

            // 检查文件是否已存在，避免重复写入
            let fileExists = fileManager.fileExists(atPath: filePath)

            if fileExists {
                // 文件已存在时更新访问时间
                updateFileAccessDate(filePath)
                completion?()
                return
            }

            // 将 CGImage 转换为数据
            guard let data = imageData(from: image) else {
                CLVideoFrameCacheLog.log("磁盘缓存写入失败: 图片转换失败, key: \(key)", level: .write)
                completion?()
                return
            }

            // 写入磁盘
            do {
                try data.write(to: URL(fileURLWithPath: filePath), options: .atomic)
                let fileSize = data.count
                CLVideoFrameCacheLog.log("磁盘缓存写入成功: \(key), 大小: \(fileSize / 1024)KB", level: .write)
                cleanDiskCacheBySize()
                completion?()
            } catch {
                CLVideoFrameCacheLog.log("磁盘缓存写入失败: \(error.localizedDescription), key: \(key)", level: .write)
                completion?()
            }
        }
    }

    // 将 CGImage 转换为数据
    private func imageData(from cgImage: CGImage) -> Data? {
        switch config.diskImageFormat {
        case .png:
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage.pngData()
        case let .jpeg(quality):
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage.jpegData(compressionQuality: quality)
        }
    }

    // 从磁盘读取图片
    func imageForKey(_ key: String, completion: @escaping (CGImage?) -> Void) {
        ioQueue.async { [weak self] in
            guard let self else {
                completion(nil)
                return
            }

            let filePath = cacheFilePath(forKey: key)

            // 检查文件是否存在
            let fileExists = fileManager.fileExists(atPath: filePath)

            guard fileExists else {
                CLVideoFrameCacheLog.log("磁盘缓存未命中: \(key)", level: .miss)
                completion(nil)
                return
            }

            // 读取文件数据
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                  let uiImage = UIImage(data: data),
                  let cgImage = uiImage.cgImage
            else {
                CLVideoFrameCacheLog.log("磁盘缓存读取失败: 数据解析失败, key: \(key)", level: .read)
                completion(nil)
                return
            }

            // 更新文件访问时间（用于 LRU）
            updateFileAccessDate(filePath)

            CLVideoFrameCacheLog.log("磁盘缓存命中: \(key)", level: .hit)
            completion(cgImage)
        }
    }

    // 更新文件访问时间
    private func updateFileAccessDate(_ filePath: String) {
        let now = Date()
        try? fileManager.setAttributes([.modificationDate: now], ofItemAtPath: filePath)
    }

    // 删除指定缓存
    func removeImageForKey(_ key: String, completion: (() -> Void)? = nil) {
        ioQueue.async { [weak self] in
            guard let self else {
                completion?()
                return
            }

            let filePath = cacheFilePath(forKey: key)
            if fileManager.fileExists(atPath: filePath) {
                try? fileManager.removeItem(atPath: filePath)
                CLVideoFrameCacheLog.log("磁盘缓存删除: \(key)", level: .delete)
            }
            completion?()
        }
    }

    // 清空所有磁盘缓存
    func clearDisk(completion: (() -> Void)? = nil) {
        ioQueue.async { [weak self] in
            guard let self else {
                completion?()
                return
            }

            if fileManager.fileExists(atPath: diskCachePath) {
                try? fileManager.removeItem(atPath: diskCachePath)
                createCacheDirectoryIfNeeded()
                CLVideoFrameCacheLog.log("磁盘缓存已清空", level: .clean)
            }
            completion?()
        }
    }

    // 清理过期缓存
    func cleanExpiredDiskCache(completion: (() -> Void)? = nil) {
        ioQueue.async { [weak self] in
            guard let self else {
                completion?()
                return
            }

            guard let fileURLs = try? fileManager.contentsOfDirectory(at: URL(fileURLWithPath: diskCachePath), includingPropertiesForKeys: [.contentModificationDateKey], options: .skipsHiddenFiles) else {
                completion?()
                return
            }

            let expirationDate = Date().addingTimeInterval(-config.diskMaxAge)
            var removedCount = 0

            for fileURL in fileURLs {
                if let modificationDate = try? fileURL.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate,
                   modificationDate < expirationDate
                {
                    try? fileManager.removeItem(at: fileURL)
                    removedCount += 1
                }
            }

            if removedCount > 0 {
                CLVideoFrameCacheLog.log("清理过期缓存: 删除 \(removedCount) 个文件", level: .clean)
            }
            completion?()
        }
    }

    // 按大小限制清理缓存（LRU）
    func cleanDiskCacheBySize(completion: (() -> Void)? = nil) {
        ioQueue.async { [weak self] in
            guard let self else {
                completion?()
                return
            }

            guard let fileURLs = try? fileManager.contentsOfDirectory(at: URL(fileURLWithPath: diskCachePath), includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey], options: .skipsHiddenFiles) else {
                completion?()
                return
            }

            // 计算总大小
            var totalSize = 0
            var filesInfo: [(url: URL, modificationDate: Date, size: Int)] = []

            for fileURL in fileURLs {
                if let resourceValues = try? fileURL.resourceValues(forKeys: [.contentModificationDateKey, .fileSizeKey]),
                   let modificationDate = resourceValues.contentModificationDate,
                   let fileSize = resourceValues.fileSize
                {
                    totalSize += fileSize
                    filesInfo.append((fileURL, modificationDate, fileSize))
                }
            }

            // 如果总大小超过限制，按修改时间排序并删除最旧的
            if totalSize > config.diskMaxBytes {
                filesInfo.sort { $0.modificationDate < $1.modificationDate }

                var removedCount = 0
                var removedSize = 0

                for fileInfo in filesInfo {
                    if totalSize - removedSize <= config.diskMaxBytes {
                        break
                    }
                    try? fileManager.removeItem(at: fileInfo.url)
                    removedSize += fileInfo.size
                    removedCount += 1
                }

                if removedCount > 0 {
                    CLVideoFrameCacheLog.log("清理超限缓存: 删除 \(removedCount) 个文件, 释放 \(removedSize / 1024 / 1024)MB", level: .clean)
                }
            }

            completion?()
        }
    }

    // 获取磁盘缓存大小
    func getDiskCacheSize(completion: @escaping (Int) -> Void) {
        ioQueue.async { [weak self] in
            guard let self else {
                completion(0)
                return
            }

            guard let fileURLs = try? fileManager.contentsOfDirectory(at: URL(fileURLWithPath: diskCachePath), includingPropertiesForKeys: [.fileSizeKey], options: .skipsHiddenFiles) else {
                completion(0)
                return
            }

            var totalSize = 0
            for fileURL in fileURLs {
                if let fileSize = try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                    totalSize += fileSize
                }
            }

            completion(totalSize)
        }
    }

    deinit {
        CLVideoFrameCacheLog.log("磁盘缓存释放", level: .info)
    }
}
