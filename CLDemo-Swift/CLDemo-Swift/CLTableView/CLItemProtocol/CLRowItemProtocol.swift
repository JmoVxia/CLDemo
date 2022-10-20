//
//  CLRowItemProtocol.swift
//  CL
//
//  Created by JmoVxia on 2020/3/26.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

protocol CLRowItemProtocol where Self: AnyObject {
    /// 将要显示cell
    var willDisplayCallback: ((IndexPath) -> Void)? { get set }
    /// cell显示结束
    var didEndDisplayingCallback: ((IndexPath) -> Void)? { get set }
    /// cellForRow
    var cellForRowCallback: ((IndexPath) -> Void)? { get set }
    /// 点击cell回调
    var didSelectCellCallback: ((IndexPath) -> Void)? { get set }
    /// cell类型
    func cellClass() -> UITableViewCell.Type
    /// 高度
    func cellHeight() -> CGFloat
}

extension CLRowItemProtocol {
    var willDisplayCallback: ((IndexPath) -> Void)? {
        get {
            return nil
        }
        set {}
    }

    var didEndDisplayingCallback: ((IndexPath) -> Void)? {
        get {
            return nil
        }
        set {}
    }

    var cellForRowCallback: ((IndexPath) -> Void)? {
        get {
            return nil
        }
        set {}
    }

    var didSelectCellCallback: ((IndexPath) -> Void)? {
        get {
            return nil
        }
        set {}
    }

    /// 高度
    func cellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
}
