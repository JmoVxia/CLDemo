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

// MARK: - CLVideoFrameDiskCache

final class CLVideoFrameDiskCache {
    private let config: CLVideoFrameCacheConfig
    private let ioQueue: DispatchQueue
    private let fileManager = FileManager.default
    private let diskCachePath: String

    init(config: CLVideoFrameCacheConfig) {
        self.config = config
        ioQueue = DispatchQueue(label: "com.clvideo.diskcache", qos: .userInitiated)

        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        diskCachePath = (cachesPath as NSString).appendingPathComponent("CLVideoFrameCache")
        createCacheDirectoryIfNeeded()
    }

    deinit {
        CLLog("CLVideoFrameDiskCache deinit")
    }
}

// MARK: - 存储

extension CLVideoFrameDiskCache {
    /// 存储图片到磁盘
    func storeImage(_ image: CGImage, forKey key: String, completion: (() -> Void)? = nil) {
        ioQueue.async {
            let filePath = self.cacheFilePath(forKey: key)

            if self.fileManager.fileExists(atPath: filePath) {
                self.updateFileAccessDate(filePath)
                completion?()
                return
            }

            guard let data = self.imageData(from: image) else {
                completion?()
                return
            }

            do {
                try data.write(to: URL(fileURLWithPath: filePath), options: .atomic)
                self.cleanDiskCacheBySize()
                completion?()
            } catch {
                completion?()
            }
        }
    }
}

// MARK: - 读取

extension CLVideoFrameDiskCache {
    /// 从磁盘读取图片
    func imageForKey(_ key: String, completion: @escaping (CGImage?) -> Void) {
        ioQueue.async {
            let filePath = self.cacheFilePath(forKey: key)

            guard self.fileManager.fileExists(atPath: filePath),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                  let uiImage = UIImage(data: data),
                  let cgImage = uiImage.cgImage
            else {
                completion(nil)
                return
            }

            self.updateFileAccessDate(filePath)
            completion(cgImage)
        }
    }

    /// 删除指定缓存
    func removeImageForKey(_ key: String, completion: (() -> Void)? = nil) {
        ioQueue.async {
            let filePath = self.cacheFilePath(forKey: key)
            if self.fileManager.fileExists(atPath: filePath) {
                try? self.fileManager.removeItem(atPath: filePath)
            }
            completion?()
        }
    }
}

// MARK: - 清理

extension CLVideoFrameDiskCache {
    /// 清空所有磁盘缓存
    func clearDisk(completion: (() -> Void)? = nil) {
        ioQueue.async {
            if self.fileManager.fileExists(atPath: self.diskCachePath) {
                try? self.fileManager.removeItem(atPath: self.diskCachePath)
                self.createCacheDirectoryIfNeeded()
            }
            CLVideoFrameCacheLog.log("磁盘缓存已清空", level: .clean)
            completion?()
        }
    }

    /// 清理过期缓存
    func cleanExpiredDiskCache(completion: (() -> Void)? = nil) {
        ioQueue.async {
            let fileURLs = self.getCachedFileURLs(includingPropertiesForKeys: [.contentModificationDateKey])
            let expirationDate = Date().addingTimeInterval(-self.config.diskMaxAge)
            var removedCount = 0

            for fileURL in fileURLs {
                if let modificationDate = try? fileURL.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate,
                   modificationDate < expirationDate
                {
                    try? self.fileManager.removeItem(at: fileURL)
                    removedCount += 1
                }
            }

            if removedCount > 0 {
                CLVideoFrameCacheLog.log("清理过期缓存: 删除 \(removedCount) 个文件", level: .clean)
            }
            completion?()
        }
    }

    /// 按大小限制清理缓存
    func cleanDiskCacheBySize(completion: (() -> Void)? = nil) {
        ioQueue.async {
            let fileURLs = self.getCachedFileURLs(includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey])
            let filesInfo = fileURLs.compactMap { fileURL -> (url: URL, date: Date, size: Int)? in
                guard let values = try? fileURL.resourceValues(forKeys: [.contentModificationDateKey, .fileSizeKey]),
                      let date = values.contentModificationDate,
                      let size = values.fileSize
                else { return nil }
                return (fileURL, date, size)
            }
            let totalSize = filesInfo.reduce(0) { $0 + $1.size }

            if totalSize > self.config.diskMaxBytes {
                let sortedFiles = filesInfo.sorted { $0.date < $1.date }
                var removedCount = 0
                var removedSize = 0

                for fileInfo in sortedFiles {
                    if totalSize - removedSize <= self.config.diskMaxBytes { break }
                    try? self.fileManager.removeItem(at: fileInfo.url)
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

    /// 获取磁盘缓存大小
    func getDiskCacheSize(completion: @escaping (Int) -> Void) {
        ioQueue.async {
            let fileURLs = self.getCachedFileURLs(includingPropertiesForKeys: [.fileSizeKey])
            let totalSize = fileURLs.reduce(0) { result, fileURL in
                let fileSize = (try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
                return result + fileSize
            }

            completion(totalSize)
        }
    }
}

// MARK: - 工具方法

extension CLVideoFrameDiskCache {
    /// 获取缓存目录下的所有文件 URL
    private func getCachedFileURLs(includingPropertiesForKeys keys: [URLResourceKey]) -> [URL] {
        (try? fileManager.contentsOfDirectory(
            at: URL(fileURLWithPath: diskCachePath),
            includingPropertiesForKeys: keys,
            options: .skipsHiddenFiles
        )) ?? []
    }

    private func createCacheDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: diskCachePath) {
            try? fileManager.createDirectory(atPath: diskCachePath, withIntermediateDirectories: true, attributes: nil)
        }
    }

    private func cacheFilePath(forKey key: String) -> String {
        let fileExtension = switch config.diskImageFormat {
        case .png: "png"
        case .jpeg: "jpg"
        }
        return (diskCachePath as NSString).appendingPathComponent("\(key).\(fileExtension)")
    }

    private func updateFileAccessDate(_ filePath: String) {
        try? fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: filePath)
    }

    private func imageData(from cgImage: CGImage) -> Data? {
        let uiImage = UIImage(cgImage: cgImage)
        switch config.diskImageFormat {
        case .png:
            return uiImage.pngData()
        case let .jpeg(quality):
            return uiImage.jpegData(compressionQuality: quality)
        }
    }
}
