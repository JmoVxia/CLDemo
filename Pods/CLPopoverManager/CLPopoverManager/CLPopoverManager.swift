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

    private var waitQueue = [String: CLPopoverProtocol]()

    private var windows = [String: CLPopoverWindow]()
}

public extension CLPopoverManager {
    @discardableResult static func mainSync<T>(execute block: () -> T) -> T {
        guard !Thread.isMainThread else { return block() }
        return DispatchQueue.main.sync { block() }
    }
}

public extension CLPopoverManager {
    private static var manager: CLPopoverManager?

    private static let singletonSemaphore: DispatchSemaphore = {
        let semap = DispatchSemaphore(value: 0)
        semap.signal()
        return semap
    }()

    private static var shared: CLPopoverManager {
        singletonSemaphore.wait()
        defer { singletonSemaphore.signal() }
        if let sharedManager = manager {
            return sharedManager
        } else {
            manager = CLPopoverManager()
            return manager!
        }
    }
}

public extension CLPopoverManager {
    /// 显示自定义弹窗
    static func show(_ controller: CLPopoverProtocol, completion: (() -> Void)? = nil) {
        mainSync {
            let shouldShow = !shared.windows.values.contains { $0.rootPopoverController?.config.popoverMode == .unique } &&
                !shared.windows.values.contains { $0.rootPopoverController?.config.identifier == controller.config.identifier && controller.config.identifier != nil } &&
                !shared.waitQueue.values.contains { $0.key != controller.key && $0.config.identifier == controller.config.identifier && controller.config.identifier != nil }

            guard shouldShow else { return }

            switch controller.config.popoverMode {
            case .queue, .interrupt:
                break
            case .replace:
                shared.windows.removeAll()
            case .unique:
                shared.windows.removeAll()
                shared.waitQueue.removeAll()
            }
            guard !(controller.config.popoverMode == .queue && !shared.windows.isEmpty) else {
                shared.waitQueue[controller.key] = controller
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
        func remove() {}
        mainSync {
            guard let window = shared.windows[key] else { return }
            window.rootPopoverController?.dismissAnimation {
                completion?()
                shared.waitQueue.removeValue(forKey: key)
                shared.windows.removeValue(forKey: key)
                guard !(shared.windows.isEmpty && shared.waitQueue.isEmpty) else { return dismissAll() }
                guard let lastController = shared.waitQueue.values.max(by: { $0.config.popoverPriority < $1.config.popoverPriority }) else { return }
                show(lastController)
            }
        }
    }

    /// 隐藏所有弹窗
    static func dismissAll() {
        mainSync {
            shared.waitQueue.removeAll()
            shared.windows.removeAll()
            manager = nil
        }
    }
}
