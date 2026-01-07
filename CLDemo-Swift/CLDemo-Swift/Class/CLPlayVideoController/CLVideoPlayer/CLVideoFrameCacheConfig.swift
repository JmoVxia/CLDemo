//
//  CLVideoFrameCacheConfig.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 缓存模式

enum CLVideoFrameCacheMode {
    case memoryOnly
    case diskOnly
    case all
}

// MARK: - 磁盘图片格式

enum CLVideoFrameDiskImageFormat {
    case png
    case jpeg(quality: CGFloat)
}

// MARK: - CLVideoFrameCacheConfig

final class CLVideoFrameCacheConfig {
    static let shared = CLVideoFrameCacheConfig()

    var cacheMode: CLVideoFrameCacheMode = .all
    var memoryMaxCount = 200
    var memoryMaxBytes = 300 * 1024 * 1024
    var diskMaxBytes = 300 * 1024 * 1024
    var diskMaxAge: TimeInterval = 7 * 24 * 60 * 60
    var diskImageFormat: CLVideoFrameDiskImageFormat = .jpeg(quality: 0.5)
    var enableLog = true

    private init() {}
}

// MARK: - 日志级别

enum CLVideoFrameCacheLogLevel: String {
    case info = "ℹ️"
    case clean = "🧹"
}

// MARK: - CLVideoFrameCacheLog

enum CLVideoFrameCacheLog {
    /// 打印默认配置
    static func defaultConfig() {
        guard CLVideoFrameCacheConfig.shared.enableLog else { return }
        let config = CLVideoFrameCacheConfig.shared
        log("缓存配置: 模式=\(config.cacheMode) 内存=\(config.memoryMaxCount)张/\(config.memoryMaxBytes / 1024 / 1024)MB 磁盘=\(config.diskMaxBytes / 1024 / 1024)MB/\(Int(config.diskMaxAge / 86400))天")
    }

    /// 打印日志
    static func log(_ message: String, level: CLVideoFrameCacheLogLevel = .info) {
        guard CLVideoFrameCacheConfig.shared.enableLog else { return }
        print("[视频帧缓存] \(level.rawValue) \(message)")
    }
}
