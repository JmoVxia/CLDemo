//
//  CLPopoverWindow.swift
//
//
//  Created by Chen JmoVxia on 2022/7/8.
//

import UIKit

// MARK: - 弹窗Window

@objcMembers public class CLPopoverWindow: UIWindow {
    public var allowsEventPenetration = false

    public var autoHideWhenPenetrated = false

    public var rootPopoverController: CLPopoverProtocol? {
        rootViewController as? CLPopoverProtocol
    }

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)

        guard view == rootViewController?.view else { return view }

        guard allowsEventPenetration else { return view }

        autoHideWhenPenetrated ? CLPopoverManager.dismiss(rootPopoverController?.key, completion: nil) : ()

        return nil
    }
}
