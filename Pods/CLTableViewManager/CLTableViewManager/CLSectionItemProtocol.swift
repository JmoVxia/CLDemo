//
//  CLSectionItemProtocol.swift
//  CLTableViewManger
//
//  Created by JmoVxia on 2025/10/16.
//

import UIKit

private var rowsKey: UInt8 = 0
private var willDisplayHeaderKey: UInt8 = 0
private var didEndDisplayingHeaderKey: UInt8 = 0
private var viewForHeaderKey: UInt8 = 0
private var didSelectHeaderKey: UInt8 = 0

private var willDisplayFooterKey: UInt8 = 0
private var didEndDisplayingFooterKey: UInt8 = 0
private var viewForFooterKey: UInt8 = 0
private var didSelectFooterKey: UInt8 = 0

/// 表示一个 TableView 的分区模型协议（Section Item）
public protocol CLSectionItemProtocol: CLDataSourceItemProtocol {
    // MARK: - Rows
    /// 内部使用的行数组（可能折叠/过滤）
    var visibleRows: [CLRowItemProtocol] { get }
    /// 对外公开的完整行数组
    var rows: [CLRowItemProtocol] { set get }

    // MARK: - Header

    /// Header 将要显示时回调，对应 UITableViewDelegate:
    /// `tableView(_:willDisplayHeaderView:forSection:)`
    var willDisplayHeader: ((Int) -> Void)? { get set }

    /// Header 显示结束时回调，对应 UITableViewDelegate:
    /// `tableView(_:didEndDisplayingHeaderView:forSection:)`
    var didEndDisplayingHeader: ((Int) -> Void)? { get set }

    /// 提供或配置 Header 视图的回调，对应 UITableViewDataSource:
    /// `tableView(_:viewForHeaderInSection:)`
    var viewForHeader: ((Int) -> Void)? { get set }

    /// Header 被点击时回调（自定义行为）
    var didSelectHeader: ((Int) -> Void)? { get set }

    /// Header 高度，默认 `UITableView.automaticDimension`
    var headerHeight: CGFloat { get }

    /// Header 视图类型（返回 nil 表示无自定义 Header）
    var headerViewType: UITableViewHeaderFooterView.Type? { get }

    // MARK: - Footer

    /// Footer 将要显示时回调，对应 UITableViewDelegate:
    /// `tableView(_:willDisplayFooterView:forSection:)`
    var willDisplayFooter: ((Int) -> Void)? { get set }

    /// Footer 显示结束时回调，对应 UITableViewDelegate:
    /// `tableView(_:didEndDisplayingFooterView:forSection:)`
    var didEndDisplayingFooter: ((Int) -> Void)? { get set }

    /// 提供或配置 Footer 视图的回调，对应 UITableViewDataSource:
    /// `tableView(_:viewForFooterInSection:)`
    var viewForFooter: ((Int) -> Void)? { get set }

    /// Footer 被点击时回调（自定义行为）
    var didSelectFooter: ((Int) -> Void)? { get set }

    /// Footer 高度，默认 `UITableView.automaticDimension`
    var footerHeight: CGFloat { get }

    /// Footer 视图类型（返回 nil 表示无自定义 Footer）
    var footerViewType: UITableViewHeaderFooterView.Type? { get }
}

public extension CLSectionItemProtocol {
    var visibleRows: [CLRowItemProtocol] {
        rows
    }

    var rows: [CLRowItemProtocol] {
        get { objc_getAssociatedObject(self, &rowsKey) as? [CLRowItemProtocol] ?? [] }
        set { objc_setAssociatedObject(self, &rowsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var willDisplayHeader: ((Int) -> Void)? {
        get { objc_getAssociatedObject(self, &willDisplayHeaderKey) as? ((Int) -> Void) }
        set { objc_setAssociatedObject(self, &willDisplayHeaderKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    var didEndDisplayingHeader: ((Int) -> Void)? {
        get { objc_getAssociatedObject(self, &didEndDisplayingHeaderKey) as? ((Int) -> Void) }
        set { objc_setAssociatedObject(self, &didEndDisplayingHeaderKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    var viewForHeader: ((Int) -> Void)? {
        get { objc_getAssociatedObject(self, &viewForHeaderKey) as? ((Int) -> Void) }
        set { objc_setAssociatedObject(self, &viewForHeaderKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    var didSelectHeader: ((Int) -> Void)? {
        get { objc_getAssociatedObject(self, &didSelectHeaderKey) as? ((Int) -> Void) }
        set { objc_setAssociatedObject(self, &didSelectHeaderKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    var headerHeight: CGFloat {
        UITableView.automaticDimension
    }

    var headerViewType: UITableViewHeaderFooterView.Type? {
        nil
    }

    var willDisplayFooter: ((Int) -> Void)? {
        get { objc_getAssociatedObject(self, &willDisplayFooterKey) as? ((Int) -> Void) }
        set { objc_setAssociatedObject(self, &willDisplayFooterKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    var didEndDisplayingFooter: ((Int) -> Void)? {
        get { objc_getAssociatedObject(self, &didEndDisplayingFooterKey) as? ((Int) -> Void) }
        set { objc_setAssociatedObject(self, &didEndDisplayingFooterKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    var viewForFooter: ((Int) -> Void)? {
        get { objc_getAssociatedObject(self, &viewForFooterKey) as? ((Int) -> Void) }
        set { objc_setAssociatedObject(self, &viewForFooterKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    var didSelectFooter: ((Int) -> Void)? {
        get { objc_getAssociatedObject(self, &didSelectFooterKey) as? ((Int) -> Void) }
        set { objc_setAssociatedObject(self, &didSelectFooterKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    var footerHeight: CGFloat {
        UITableView.automaticDimension
    }

    var footerViewType: UITableViewHeaderFooterView.Type? {
        nil
    }
}
