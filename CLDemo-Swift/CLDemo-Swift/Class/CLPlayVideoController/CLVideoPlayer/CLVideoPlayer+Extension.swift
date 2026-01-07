//
//  CLVideoPlayer+Extension.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/5/8.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

// MARK: - CL 命名空间包装器

public struct CLWrapper<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

// MARK: - CLCompatible 协议

public protocol CLCompatible: AnyObject {}

public extension CLCompatible {
    var cl: CLWrapper<Self> {
        CLWrapper(self)
    }

    static var cl: CLWrapper<Self>.Type {
        CLWrapper<Self>.self
    }
}

// MARK: - UIView 遵循 CLCompatible

extension UIView: CLCompatible {}

// MARK: - UIView 视频播放扩展

public extension CLWrapper where Base: UIView {
    /// 当前关联的视频 URL
    var videoURL: URL? {
        get { objc_getAssociatedObject(base, &AssociatedKeys.videoURL) as? URL }
        nonmutating set { objc_setAssociatedObject(base, &AssociatedKeys.videoURL, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// 播放视频
    /// - Parameter url: 视频 URL
    func playVideo(with url: URL) {
        CLVideoPlayer.play(url, bindTo: base)
    }

    /// 取消视频播放
    func cancelVideoPlayback() {
        CLVideoPlayer.cancelForView(base)
    }
}

// MARK: - 关联键

private enum AssociatedKeys {
    static var videoURL: UInt8 = 0
}
