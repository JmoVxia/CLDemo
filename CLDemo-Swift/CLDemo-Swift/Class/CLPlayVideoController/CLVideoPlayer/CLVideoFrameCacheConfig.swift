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
    case memoryOnly // 仅内存缓存
    case diskOnly // 仅磁盘缓存
    case all // 内存+磁盘缓存
}

// MARK: - 磁盘图片格式

enum CLVideoFrameDiskImageFormat {
    case png
    case jpeg(quality: CGFloat)
}

// MARK: - 缓存配置

class CLVideoFrameCacheConfig {
    static let shared = CLVideoFrameCacheConfig()

    // 缓存模式
    var cacheMode: CLVideoFrameCacheMode = .all

    // 内存缓存最大数量（张）
    var memoryMaxCount: Int = 150

    // 内存缓存最大内存（字节）
    var memoryMaxBytes: Int = 100 * 1024 * 1024

    // 磁盘缓存最大大小（字节）
    var diskMaxBytes: Int = 200 * 1024 * 1024

    // 磁盘缓存最长时间（秒）
    var diskMaxAge: TimeInterval = 7 * 24 * 60 * 60

    // 磁盘图片格式
    var diskImageFormat: CLVideoFrameDiskImageFormat = .jpeg(quality: 0.5)

    // 是否启用日志
    var enableLog: Bool = false

    private init() {}
}

// MARK: - 日志工具

enum CLVideoFrameCacheLogLevel: String {
    case info = "ℹ️"
    case read = "📖"
    case write = "✍️"
    case delete = "🗑️"
    case clean = "🧹"
    case hit = "✅"
    case miss = "❌"
}

class CLVideoFrameCacheLog {
    static func defaultConfig() {
        log("缓存配置初始化", level: .info)
        log("  - 缓存模式: \(CLVideoFrameCacheConfig.shared.cacheMode)", level: .info)
        log("  - 内存最大数量: \(CLVideoFrameCacheConfig.shared.memoryMaxCount)张", level: .info)
        log("  - 内存最大大小: \(CLVideoFrameCacheConfig.shared.memoryMaxBytes / 1024 / 1024)MB", level: .info)
        log("  - 磁盘最大大小: \(CLVideoFrameCacheConfig.shared.diskMaxBytes / 1024 / 1024)MB", level: .info)
        log("  - 磁盘最长时间: \(Int(CLVideoFrameCacheConfig.shared.diskMaxAge / 86400))天", level: .info)
    }

    static func log(_ message: String, level: CLVideoFrameCacheLogLevel = .info) {
        guard CLVideoFrameCacheConfig.shared.enableLog else { return }
        print("[视频帧缓存] \(level.rawValue) \(message)")
    }
}
