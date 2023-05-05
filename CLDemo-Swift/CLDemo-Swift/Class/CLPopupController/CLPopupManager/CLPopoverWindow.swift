//
//  CLPopoverWindow.swift
//  CKDDoctor
//
//  Created by Chen JmoVxia on 2022/7/8.
//

import UIKit

// MARK: - 弹窗Window

@objcMembers public class CLPopoverWindow: UIWindow {
    /// 向下传递手势
    public var isPenetrate = false

    public var autoHiddenWhenPenetrate = false

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == rootViewController?.view {
            if isPenetrate {
                if autoHiddenWhenPenetrate {
                    (rootViewController as? CLPopoverController)?.hidden()
                }
                return nil
            }
            return view
        }
        return view
    }

    deinit {}
}
