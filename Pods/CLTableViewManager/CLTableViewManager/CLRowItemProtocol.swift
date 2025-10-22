//
//  CLRowItemProtocol.swift
//  CLTableViewManger
//
//  Created by JmoVxia on 2025/10/16.
//

import UIKit

private var willDisplayKey: UInt8 = 0
private var didEndDisplayingKey: UInt8 = 0
private var cellForRowKey: UInt8 = 0
private var didSelectKey: UInt8 = 0
private var cellHeightKey: UInt8 = 0

/// 表示一个 TableView 的行模型协议（Row Item）
public protocol CLRowItemProtocol: CLDataSourceItemProtocol {
    // MARK: - 生命周期回调

    /// 将要显示 Cell 时调用，对应 UITableViewDelegate:
    /// `tableView(_:willDisplay:forRowAt:)`
    var willDisplay: ((IndexPath) -> Void)? { get set }

    /// Cell 显示结束时调用，对应 UITableViewDelegate:
    /// `tableView(_:didEndDisplaying:forRowAt:)`
    var didEndDisplaying: ((IndexPath) -> Void)? { get set }

    /// 提供或配置 Cell 的回调，对应 UITableViewDataSource:
    /// `tableView(_:cellForRowAt:)`
    var cellForRow: ((IndexPath) -> Void)? { get set }

    /// 点击 Cell 时调用，对应 UITableViewDelegate:
    /// `tableView(_:didSelectRowAt:)`
    var didSelect: ((IndexPath) -> Void)? { get set }

    // MARK: - 基本信息

    /// Cell 类型（用于注册与复用）
    var cellType: UITableViewCell.Type { get }

    /// Cell 高度（默认 `UITableView.automaticDimension`）
    var cellHeight: CGFloat { get }
}

// MARK: - 默认实现

public extension CLRowItemProtocol {
    var willDisplay: ((IndexPath) -> Void)? {
        get { objc_getAssociatedObject(self, &willDisplayKey) as? ((IndexPath) -> Void) }
        set { objc_setAssociatedObject(self, &willDisplayKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    var didEndDisplaying: ((IndexPath) -> Void)? {
        get { objc_getAssociatedObject(self, &didEndDisplayingKey) as? ((IndexPath) -> Void) }
        set { objc_setAssociatedObject(self, &didEndDisplayingKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    var cellForRow: ((IndexPath) -> Void)? {
        get { objc_getAssociatedObject(self, &cellForRowKey) as? ((IndexPath) -> Void) }
        set { objc_setAssociatedObject(self, &cellForRowKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    var didSelect: ((IndexPath) -> Void)? {
        get { objc_getAssociatedObject(self, &didSelectKey) as? ((IndexPath) -> Void) }
        set { objc_setAssociatedObject(self, &didSelectKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    var cellHeight: CGFloat {
        UITableView.automaticDimension
    }
}
