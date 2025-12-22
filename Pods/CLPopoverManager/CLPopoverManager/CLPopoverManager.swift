//
//  CLPopoverManager
//
//
//  Created by Chen JmoVxia on 2019/12/24.
//

import UIKit

private extension CLPopoverManager {
    struct CLPopoverQueueItem {
        let controller: CLPopoverProtocol
        let enqueueTime = Date()
        let completion: (() -> Void)?
    }
}

// MARK: - 弹窗管理者

@objcMembers public class CLPopoverManager: NSObject {
    override private init() {
        super.init()
    }

    deinit {}

    private static let shared = CLPopoverManager()

    private var waitQueue = [String: CLPopoverQueueItem]()

    private var activeWindows = [CLPopoverWindow]()

    private var suspendedWindows = [String: [CLPopoverWindow]]()

    private var dismissingKeys = Set<String>()
}

public extension CLPopoverManager {
    /// 显示自定义弹窗
    static func show(_ controller: CLPopoverProtocol, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            guard !shared.activeWindows.contains(where: { window in
                guard let root = window.rootPopoverController else { return false }
                return root.config.popoverMode == .unique
                    || root.key == controller.key
                    || (root.config.identifier != nil && root.config.identifier == controller.config.identifier)
            }) else {
                return
            }

            guard !shared.waitQueue.values.contains(where: {
                $0.controller.config.identifier != nil && $0.controller.config.identifier == controller.config.identifier
            }) else {
                return
            }

            switch controller.config.popoverMode {
            case .queue, .interrupt:
                break
            case .suspend:
                shared.suspendedWindows[controller.key] = shared.activeWindows
                shared.activeWindows.forEach { $0.isHidden = true }
                shared.activeWindows.removeAll()
            case .replaceInheritSuspend:
                let windowsToReplace = shared.activeWindows
                windowsToReplace.forEach { $0.isHidden = true }
                shared.activeWindows.removeAll()

                var allInheritedSuspended = [CLPopoverWindow]()
                for window in windowsToReplace {
                    guard let replacedKey = window.rootPopoverController?.key else { continue }
                    guard let suspended = shared.suspendedWindows.removeValue(forKey: replacedKey) else { continue }
                    allInheritedSuspended.append(contentsOf: suspended)
                }
                guard !allInheritedSuspended.isEmpty else { break }
                shared.suspendedWindows[controller.key] = allInheritedSuspended
            case .replaceClearSuspend:
                let windowsToReplace = shared.activeWindows
                windowsToReplace.forEach { $0.isHidden = true }
                shared.activeWindows.removeAll()
                for window in windowsToReplace {
                    guard let replacedKey = window.rootPopoverController?.key else { continue }
                    guard let suspendedToClear = shared.suspendedWindows.removeValue(forKey: replacedKey) else { continue }
                    suspendedToClear.forEach { $0.isHidden = true }
                }
            case .replaceAll, .unique:
                shared.waitQueue.removeAll()
                shared.suspendedWindows.values.flatMap { $0 }.forEach { $0.isHidden = true }
                shared.suspendedWindows.removeAll()
                shared.activeWindows.forEach { $0.isHidden = true }
                shared.activeWindows.removeAll()
            }
            if controller.config.popoverMode == .queue, !shared.activeWindows.isEmpty {
                shared.waitQueue[controller.key] = CLPopoverQueueItem(controller: controller, completion: completion)
                return
            }
            display(controller, completion: completion)
        }
    }

    /// 隐藏指定弹窗
    static func dismiss(_ key: String?, completion: (() -> Void)? = nil) {
        guard let key else { return }
        DispatchQueue.main.async {
            guard !shared.dismissingKeys.contains(key) else { return }
            guard let window = shared.activeWindows.first(where: { $0.rootPopoverController?.key == key }) else {
                shared.waitQueue.removeValue(forKey: key)
                completion?()
                return
            }
            shared.dismissingKeys.insert(key)
            window.rootPopoverController?.dismissAnimation {
                window.isHidden = true
                completion?()
                shared.activeWindows.removeAll(where: { $0.rootPopoverController?.key == key })
                shared.dismissingKeys.remove(key)
                if shared.activeWindows.isEmpty, shared.suspendedWindows.isEmpty, shared.waitQueue.isEmpty { return dismissAll() }
                guard shared.activeWindows.isEmpty else { return }
                if let windows = shared.suspendedWindows[key], !windows.isEmpty {
                    windows.forEach { $0.isHidden = false }
                    shared.activeWindows = windows
                    shared.suspendedWindows.removeValue(forKey: key)
                } else if let nextItem = shared.waitQueue.values.max(by: { lhs, rhs in
                    if lhs.controller.config.popoverPriority != rhs.controller.config.popoverPriority {
                        lhs.controller.config.popoverPriority < rhs.controller.config.popoverPriority
                    } else {
                        lhs.enqueueTime > rhs.enqueueTime
                    }
                }) {
                    display(nextItem.controller, completion: nextItem.completion)
                }
            }
        }
    }

    /// 隐藏所有弹窗
    static func dismissAll() {
        DispatchQueue.main.async {
            shared.dismissingKeys.removeAll()
            shared.waitQueue.removeAll()
            shared.suspendedWindows.values.flatMap { $0 }.forEach { $0.isHidden = true }
            shared.suspendedWindows.removeAll()
            shared.activeWindows.forEach { $0.isHidden = true }
            shared.activeWindows.removeAll()
        }
    }
}

private extension CLPopoverManager {
    static func display(_ controller: CLPopoverProtocol, completion: (() -> Void)? = nil) {
        let window: CLPopoverWindow = {
            if #available(iOS 13.0, *) {
                let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
                let preferredScene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
                let popoverWindow = preferredScene.map { CLPopoverWindow(windowScene: $0) } ?? CLPopoverWindow(frame: UIScreen.main.bounds)
                popoverWindow.overrideUserInterfaceStyle = .init(rawValue: controller.config.userInterfaceStyleOverride.rawValue) ?? .light
                return popoverWindow
            } else {
                return CLPopoverWindow(frame: UIScreen.main.bounds)
            }
        }()

        window.backgroundColor = .clear
        window.autoHideWhenPenetrated = controller.config.autoHideWhenPenetrated
        window.allowsEventPenetration = controller.config.allowsEventPenetration
        window.windowLevel = .alert + 50
        window.rootViewController = controller
        window.makeKeyAndVisible()
        shared.activeWindows.append(window)
        shared.waitQueue.removeValue(forKey: controller.key)
        controller.showAnimation(completion: completion)
    }
}
