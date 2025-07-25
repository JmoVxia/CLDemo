//
//  CLPopoverManager
//
//
//  Created by Chen JmoVxia on 2019/12/24.
//

import UIKit

// MARK: - 弹窗管理者

@objcMembers public class CLPopoverManager: NSObject {
    override private init() {
        super.init()
    }

    deinit {}

    private static let shared = CLPopoverManager()

    private var waitQueue = [String: (controller: CLPopoverProtocol, enqueueTime: Date)]()

    private var windows = [String: CLPopoverWindow]()

    private var dismissingKeys = Set<String>()
}

public extension CLPopoverManager {
    /// 显示自定义弹窗
    static func show(_ controller: CLPopoverProtocol, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            guard !shared.windows.values.contains(where: { window in
                guard let root = window.rootPopoverController else { return false }
                return root.config.popoverMode == .unique
                    || root.key == controller.key
                    || (root.config.identifier != nil && root.config.identifier == controller.config.identifier)
            }) else {
                return
            }

            guard !shared.waitQueue.values.contains(where: { waitController, _ in
                waitController.config.identifier != nil && waitController.config.identifier == controller.config.identifier
            }) else {
                return
            }

            switch controller.config.popoverMode {
            case .queue, .interrupt:
                break
            case .replaceActive:
                shared.windows.values.forEach { $0.isHidden = true }
                shared.windows.removeAll()
            case .replaceAll, .unique:
                shared.waitQueue.removeAll()
                shared.windows.values.forEach { $0.isHidden = true }
                shared.windows.removeAll()
            }
            guard !(controller.config.popoverMode == .queue && !shared.windows.isEmpty) else {
                shared.waitQueue[controller.key] = (controller: controller, enqueueTime: Date())
                return
            }
            let window = CLPopoverWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .clear
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = .init(rawValue: controller.config.userInterfaceStyleOverride.rawValue) ?? .light
            }
            window.autoHideWhenPenetrated = controller.config.autoHideWhenPenetrated
            window.allowsEventPenetration = controller.config.allowsEventPenetration
            window.windowLevel = .alert + 50
            window.rootViewController = controller
            window.makeKeyAndVisible()
            shared.windows[controller.key] = window
            shared.waitQueue.removeValue(forKey: controller.key)
            controller.showAnimation(completion: completion)
        }
    }

    /// 隐藏指定弹窗
    static func dismiss(_ key: String?, completion: (() -> Void)? = nil) {
        guard let key else { return }
        DispatchQueue.main.async {
            guard !shared.dismissingKeys.contains(key) else { return }
            guard let window = shared.windows[key] else {
                shared.waitQueue.removeValue(forKey: key)
                completion?()
                return
            }
            shared.dismissingKeys.insert(key)
            window.rootPopoverController?.dismissAnimation {
                window.isHidden = true
                completion?()
                shared.windows.removeValue(forKey: key)
                shared.dismissingKeys.remove(key)
                guard !(shared.windows.isEmpty && shared.waitQueue.isEmpty) else { return dismissAll() }
                guard let nextController = shared.waitQueue.values.sorted(by: {
                    $0.controller.config.popoverPriority != $1.controller.config.popoverPriority ?
                        $0.controller.config.popoverPriority > $1.controller.config.popoverPriority :
                        $0.enqueueTime < $1.enqueueTime
                }).first?.controller else { return }
                show(nextController)
            }
        }
    }

    /// 隐藏所有弹窗
    static func dismissAll() {
        DispatchQueue.main.async {
            shared.dismissingKeys.removeAll()
            shared.waitQueue.removeAll()
            shared.windows.values.forEach { $0.isHidden = true }
            shared.windows.removeAll()
        }
    }
}
