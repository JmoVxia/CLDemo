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

private extension CLPopoverManager {
    func activeWindows(for groupID: String?) -> [CLPopoverWindow] {
        activeWindows.filter { $0.rootPopoverController?.config.groupID == groupID }
    }

    func waitQueueItems(for groupID: String?) -> [String: CLPopoverQueueItem] {
        waitQueue.filter { $0.value.controller.config.groupID == groupID }
    }

    func suspendedWindows(for groupID: String?) -> [String: [CLPopoverWindow]] {
        suspendedWindows.filter { _, windows in
            guard let firstWindow = windows.first else { return false }
            return firstWindow.rootPopoverController?.config.groupID == groupID
        }
    }
}

public extension CLPopoverManager {
    /// 显示自定义弹窗
    static func show(_ controller: CLPopoverProtocol, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let groupID = controller.config.groupID

            if shared.activeWindows.contains(where: { $0.rootPopoverController?.config.popoverMode == .globalUnique }) {
                return
            }

            let sameGroupHasUnique = shared.activeWindows.contains(where: {
                guard let ctrl = $0.rootPopoverController else { return false }
                return ctrl.config.popoverMode == .groupUnique && ctrl.config.groupID == groupID
            })
            if sameGroupHasUnique {
                return
            }

            let allExistingControllers: [CLPopoverProtocol] = {
                var controllers = [CLPopoverProtocol]()
                controllers.append(contentsOf: shared.activeWindows.compactMap(\.rootPopoverController))
                controllers.append(contentsOf: shared.waitQueue.values.map(\.controller))
                controllers.append(contentsOf: shared.suspendedWindows.values.flatMap { $0 }.compactMap(\.rootPopoverController))
                return controllers
            }()

            let controllerKey = controller.key
            let controllerIdentifier = controller.config.identifier

            if allExistingControllers.contains(where: {
                $0.key == controllerKey || (controllerIdentifier != nil && $0.config.identifier == controllerIdentifier)
            }) {
                return
            }

            switch controller.config.popoverMode {
            case .queue, .interrupt:
                break

            case .suspend:
                let sameGroupWindows = shared.activeWindows(for: groupID)
                shared.suspendedWindows[controller.key] = sameGroupWindows
                sameGroupWindows.forEach { $0.isHidden = true }
                shared.activeWindows.removeAll { $0.rootPopoverController?.config.groupID == groupID }

            case .replaceInheritSuspend:
                let windowsToReplace = shared.activeWindows(for: groupID)
                windowsToReplace.forEach { $0.isHidden = true }
                shared.activeWindows.removeAll { $0.rootPopoverController?.config.groupID == groupID }

                var allInheritedSuspended = [CLPopoverWindow]()
                for window in windowsToReplace {
                    guard let replacedKey = window.rootPopoverController?.key else { continue }
                    guard let suspended = shared.suspendedWindows.removeValue(forKey: replacedKey) else { continue }
                    allInheritedSuspended.append(contentsOf: suspended)
                }
                if !allInheritedSuspended.isEmpty {
                    shared.suspendedWindows[controller.key] = allInheritedSuspended
                }

            case .replaceClearSuspend:
                let windowsToReplace = shared.activeWindows(for: groupID)
                windowsToReplace.forEach { $0.isHidden = true }
                shared.activeWindows.removeAll { $0.rootPopoverController?.config.groupID == groupID }
                for window in windowsToReplace {
                    guard let replacedKey = window.rootPopoverController?.key else { continue }
                    guard let suspendedToClear = shared.suspendedWindows.removeValue(forKey: replacedKey) else { continue }
                    suspendedToClear.forEach { $0.isHidden = true }
                }

            case .replaceAll, .groupUnique:
                shared.waitQueue = shared.waitQueue.filter { $0.value.controller.config.groupID != groupID }

                let sameGroupSuspendedKeys = shared.suspendedWindows(for: groupID).keys
                for key in sameGroupSuspendedKeys {
                    shared.suspendedWindows[key]?.forEach { $0.isHidden = true }
                    shared.suspendedWindows.removeValue(forKey: key)
                }

                let sameGroupActiveWindows = shared.activeWindows(for: groupID)
                sameGroupActiveWindows.forEach { $0.isHidden = true }
                shared.activeWindows.removeAll { $0.rootPopoverController?.config.groupID == groupID }

            case .globalUnique:
                shared.waitQueue.removeAll()
                shared.suspendedWindows.values.flatMap { $0 }.forEach { $0.isHidden = true }
                shared.suspendedWindows.removeAll()
                shared.activeWindows.forEach { $0.isHidden = true }
                shared.activeWindows.removeAll()
            }

            if controller.config.popoverMode == .queue, !shared.activeWindows(for: groupID).isEmpty {
                shared.waitQueue[controller.key] = CLPopoverQueueItem(controller: controller, completion: completion)
                return
            }

            display(controller, completion: completion)
        }
    }

    /// 隐藏指定弹窗
    static func dismiss(forKey key: String?, completion: (() -> Void)? = nil) {
        guard let key else { return }
        DispatchQueue.main.async {
            guard !shared.dismissingKeys.contains(key) else { return }
            guard let window = shared.activeWindows.first(where: { $0.rootPopoverController?.key == key }) else {
                shared.waitQueue.removeValue(forKey: key)
                completion?()
                return
            }

            let groupID = window.rootPopoverController?.config.groupID

            shared.dismissingKeys.insert(key)
            window.rootPopoverController?.dismissAnimation {
                window.isHidden = true
                completion?()
                shared.activeWindows.removeAll(where: { $0.rootPopoverController?.key == key })
                shared.dismissingKeys.remove(key)

                if shared.activeWindows.isEmpty, shared.suspendedWindows.isEmpty, shared.waitQueue.isEmpty {
                    return dismissAll()
                }

                guard shared.activeWindows(for: groupID).isEmpty else { return }

                if let windows = shared.suspendedWindows[key], !windows.isEmpty {
                    windows.forEach { $0.isHidden = false }
                    shared.activeWindows.append(contentsOf: windows)
                    shared.suspendedWindows.removeValue(forKey: key)
                    return
                }

                let sameGroupWaitQueue = shared.waitQueueItems(for: groupID)
                if let nextItem = sameGroupWaitQueue.values.max(by: { lhs, rhs in
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

    /// 隐藏指定分组的所有弹窗
    static func dismiss(forGroup groupID: String) {
        DispatchQueue.main.async {
            shared.waitQueue = shared.waitQueue.filter { $0.value.controller.config.groupID != groupID }

            let sameGroupSuspendedKeys = shared.suspendedWindows(for: groupID).keys
            for key in sameGroupSuspendedKeys {
                shared.suspendedWindows[key]?.forEach { $0.isHidden = true }
                shared.suspendedWindows.removeValue(forKey: key)
            }

            let sameGroupActiveWindows = shared.activeWindows(for: groupID)
            sameGroupActiveWindows.forEach { $0.isHidden = true }
            shared.activeWindows.removeAll { $0.rootPopoverController?.config.groupID == groupID }

            let keysToRemove = shared.dismissingKeys.filter { key in
                sameGroupActiveWindows.contains { $0.rootPopoverController?.key == key }
            }
            shared.dismissingKeys.subtract(keysToRemove)
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

// MARK: - 状态查询（用于测试）

public extension CLPopoverManager {
    /// 获取当前活跃弹窗数量
    static var activeCount: Int {
        shared.activeWindows.count
    }

    /// 获取指定分组的活跃弹窗数量
    static func activeCount(for groupID: String?) -> Int {
        shared.activeWindows(for: groupID).count
    }

    /// 获取当前等待队列数量
    static var waitQueueCount: Int {
        shared.waitQueue.count
    }

    /// 获取指定分组的等待队列数量
    static func waitQueueCount(for groupID: String?) -> Int {
        shared.waitQueueItems(for: groupID).count
    }

    /// 获取当前挂起弹窗数量
    static var suspendedCount: Int {
        shared.suspendedWindows.values.flatMap { $0 }.count
    }

    /// 获取指定分组的挂起弹窗数量
    static func suspendedCount(for groupID: String?) -> Int {
        shared.suspendedWindows(for: groupID).values.flatMap { $0 }.count
    }

    /// 获取所有活跃弹窗的 identifier 列表
    static var activeIdentifiers: [String] {
        shared.activeWindows.compactMap { $0.rootPopoverController?.config.identifier }
    }

    /// 获取指定分组的活跃弹窗 identifier 列表
    static func activeIdentifiers(for groupID: String?) -> [String] {
        shared.activeWindows(for: groupID).compactMap { $0.rootPopoverController?.config.identifier }
    }

    /// 检查指定 identifier 的弹窗是否正在显示
    static func isActive(identifier: String) -> Bool {
        shared.activeWindows.contains { $0.rootPopoverController?.config.identifier == identifier }
    }

    /// 检查指定 identifier 的弹窗是否在等待队列中
    static func isInWaitQueue(identifier: String) -> Bool {
        shared.waitQueue.values.contains { $0.controller.config.identifier == identifier }
    }

    /// 检查指定 identifier 的弹窗是否被挂起
    static func isSuspended(identifier: String) -> Bool {
        shared.suspendedWindows.values.flatMap { $0 }.contains { $0.rootPopoverController?.config.identifier == identifier }
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
