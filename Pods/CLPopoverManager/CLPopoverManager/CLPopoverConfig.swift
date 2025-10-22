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

    public enum CLDisplayMode {
        /// 排队，如果没有正在显示，会立即显示，如果有正在显示，会加入到等待队列，后续按照优先级显示
        case queue
        /// 插队，立即展示，可能会重叠
        case interrupt
        /// 挂起当前可见的所有弹窗，并显示自己，当自己消失后，恢复被挂起的弹窗
        case suspend
        /// 替换当前正在显示的弹窗，并继承其挂起链，不会移除等待中的弹窗
        case replaceInheritSuspend
        /// 替换当前已显示弹窗，并清除其挂起链，不会移除等待中的弹窗
        case replaceClearSuspend
        /// 替换当前正在显示的弹窗，会移除被挂起的弹窗，也会移除等待中的弹窗
        case replaceAll
        /// 唯一，替换当前正在显示的弹窗，会移除被挂起的弹窗，也会移除等待中的弹窗，会阻止后续所有弹窗
        case unique
    }

    /// 弹窗的唯一标识符，用于去重
    public var identifier: String?
    /// 弹窗模式
    public var popoverMode: CLDisplayMode = .queue
    /// 弹窗优先级，只影响等待队列
    public var popoverPriority: CLPopoverPriority = .medium
    /// 是否允许手势穿透
    public var allowsEventPenetration = false
    /// 手势穿透时是否自动隐藏
    public var autoHideWhenPenetrated = false
    /// 是否自动旋转屏幕，继承CLPopoverController才生效
    public var shouldAutorotate = false
    /// 是否隐藏状态栏，继承CLPopoverController才生效
    public var prefersStatusBarHidden = false
    /// 状态栏样式，继承CLPopoverController才生效
    public var preferredStatusBarStyle = UIStatusBarStyle.lightContent
    /// 支持的界面方向，继承CLPopoverController才生效
    public var supportedInterfaceOrientations = UIInterfaceOrientationMask.portrait
    /// 用户界面样式，包括夜间模式，继承CLPopoverController才生效
    public var userInterfaceStyleOverride = CLUserInterfaceStyle.light
}
