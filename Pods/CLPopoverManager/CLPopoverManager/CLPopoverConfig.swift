//
//  CLPopoverConfig.swift
//
//
//  Created by Chen JmoVxia on 2022/11/3.
//

import Foundation
import UIKit

// MARK: - 弹窗配置

/// 配置
@objcMembers public class CLPopoverConfig: NSObject {
    public enum CLUserInterfaceStyle: Int {
        case unspecified = 0
        case light = 1
        case dark = 2
    }

    public enum CLPopoverPriority {
        case low
        case mediumLow
        case medium
        case mediumHigh
        case high
        case customValue(Int)
        var rawValue: Int {
            switch self {
            case .low:
                0
            case .mediumLow:
                250
            case .medium:
                500
            case .mediumHigh:
                750
            case .high:
                1000
            case let .customValue(value):
                value
            }
        }

        static func > (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue > rhs.rawValue
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue < rhs.rawValue
        }

        static func >= (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue >= rhs.rawValue
        }

        static func <= (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue <= rhs.rawValue
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue == rhs.rawValue
        }

        static func != (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue != rhs.rawValue
        }
    }

    public enum CLMode {
        /// 排队
        case queue
        /// 插队
        case interrupt
        /// 替换
        case replace
        /// 唯一
        case unique
    }

    /// 弹窗模式
    public var popoverMode: CLMode = .queue
    /// 弹窗优先级，只影响等待队列
    public var popoverPriority: CLPopoverPriority = .medium
    /// 是否允许手势穿透
    public var allowsEventPenetration = false
    /// 手势穿透时是否自动隐藏
    public var autoHideWhenPenetrated = false
    /// 是否自动旋转屏幕
    public var shouldAutorotate = false
    /// 是否隐藏状态栏
    public var prefersStatusBarHidden = false
    /// 状态栏样式
    public var preferredStatusBarStyle = UIStatusBarStyle.lightContent
    /// 支持的界面方向
    public var supportedInterfaceOrientations = UIInterfaceOrientationMask.portrait
    /// 用户界面样式，包括夜间模式
    public var userInterfaceStyleOverride = CLUserInterfaceStyle.light
    /// 弹窗的唯一标识符，用于去重
    public var identifier: String?
}
