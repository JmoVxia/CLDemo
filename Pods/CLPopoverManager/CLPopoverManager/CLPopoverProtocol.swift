//
//  CLPopoverProtocol.swift
//
//
//  Created by Chen JmoVxia on 2023/6/27.
//

import UIKit

private var cl_configKey: UInt8 = 0

public protocol CLPopoverProtocol where Self: UIViewController {
    /// 配置
    var config: CLPopoverConfig { get set }
    /// 惟一的key
    var key: String { get }
    /// 显示
    func showAnimation(completion: (() -> Void)?)
    /// 隐藏
    func dismissAnimation(completion: (() -> Void)?)
}

public extension CLPopoverProtocol {
    var key: String {
        "\(Unmanaged.passUnretained(self).toOpaque())"
    }

    var config: CLPopoverConfig {
        get {
            guard let obj = objc_getAssociatedObject(self, &cl_configKey) as? CLPopoverConfig else {
                let defaultConfig = CLPopoverConfig()
                objc_setAssociatedObject(self, &cl_configKey, defaultConfig, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return defaultConfig
            }
            return obj
        }
        set { objc_setAssociatedObject(self, &cl_configKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func showAnimation(completion: (() -> Void)?) {}

    func dismissAnimation(completion: (() -> Void)?) {}
}
