
import UIKit

// MARK: - 弹窗Window

@objcMembers public class CLPopoverWindow: UIWindow {
    /// 向下传递手势
    public var isPenetrate = false

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == rootViewController?.view {
            return isPenetrate ? nil : view
        }
        return view
    }

    deinit {
    }

    @available(iOS 13.0, *)
    public override var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        set {
            super.overrideUserInterfaceStyle = newValue
        }
        get {
            return .light
        }
    }
}
