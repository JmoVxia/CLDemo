//
//  CLPopoverProtocol.swift
//
//
//  Created by Chen JmoVxia on 2023/6/27.
//

import Foundation

public protocol CLPopoverProtocol where Self: CLPopoverController {
    /// 显示
    func showAnimation(completion: (() -> Void)?)
    /// 隐藏
    func dismissAnimation(completion: (() -> Void)?)
}
