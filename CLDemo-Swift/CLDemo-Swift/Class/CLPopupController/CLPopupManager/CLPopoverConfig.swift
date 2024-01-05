//
//  CLPopoverConfig.swift
//  CKDDoctor
//
//  Created by Chen JmoVxia on 2022/11/3.
//

import Foundation
import UIKit

// MARK: - 弹窗配置

@objcMembers public class CLPopoverConfig: NSObject {
    public enum CLPopoverPriority: Int, Equatable {
        case veryLow = 0
        case low = 250
        case normal = 500
        case high = 750
        case veryHigh = 1000

        static func > (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue > rhs.rawValue
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    public enum CKDMode {
        /// 共存
        case coexistence
        /// 移除之前
        case removeBefore
        /// 唯一
        case unique
    }

    /// 优先级
    public var priority: CLPopoverPriority = .normal
    /// 模式
    public var mode: CKDMode = .removeBefore
    /// 手势穿透
    public var shouldPenetrate = false
    /// 手势穿透时自动隐藏
    public var autoHiddenWhenPenetrate = false
    /// 是否等待
    public var shouldWait = true
    /// 是否自动旋转
    public var shouldAutorotate = false
    /// 是否隐藏状态栏
    public var prefersStatusBarHidden = false
    /// 状态栏颜色
    public var preferredStatusBarStyle = UIStatusBarStyle.lightContent
    /// 支持方向
    public var supportedInterfaceOrientations = UIInterfaceOrientationMask.portrait
    /// 夜间模式
    public var overrideUserInterfaceStyle: UIUserInterfaceStyle = .light
    /// 去重标识
    public var identifier: String?
}
