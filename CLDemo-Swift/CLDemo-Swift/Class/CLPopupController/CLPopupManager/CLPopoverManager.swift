//
//  swift
//  FUSHENG
//
//  Created by JmoVxia on 2019/12/24.
//  Copyright © 2019 FuSheng. All rights reserved.
//

import UIKit

// MARK: - 弹窗管理者

@objcMembers public class CLPopoverManager: NSObject {
    override private init() {
        super.init()
    }

    deinit {
    }

    private var waitQueue = [String: CLPopoverController]()
    private var windows = [String: CLPopoverWindow]()

    /// 切换到主线程同步执行
    @discardableResult static func mainSync<T>(execute block: () -> T) -> T {
        guard !Thread.isMainThread else { return block() }
        return DispatchQueue.main.sync { return block() }
    }
    
    static var keyWindow: UIWindow? = {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap{$0 as? UIWindowScene}
                .flatMap{$0.windows}
                .first{$0.isKeyWindow}
        } else {
            return UIApplication.shared.keyWindow
        }
    }()
}

public extension CLPopoverManager {
    private static var manager: CLPopoverManager?
    private static let singletonSemaphore: DispatchSemaphore = {
        let semap = DispatchSemaphore(value: 0)
        semap.signal()
        return semap
    }()

    private static var share: CLPopoverManager {
        singletonSemaphore.wait()
        guard let sharedManager = manager else {
            manager = CLPopoverManager()
            singletonSemaphore.signal()
            return manager!
        }
        singletonSemaphore.signal()
        return sharedManager
    }
}

public extension CLPopoverManager {
    /// 显示自定义弹窗
    static func show(_ controller: CLPopoverController) {
        guard !share.windows.values.contains(where: { ($0.rootViewController as? CLPopoverController)?.config.mode == .unique }) else { return }
        guard !share.windows.values.contains(where: { ($0.rootViewController as? CLPopoverController)?.config.identifier == controller.config.identifier && controller.config.identifier != nil }) else { return }
        guard !share.waitQueue.values.contains(where: { $0 != controller && $0.config.identifier == controller.config.identifier && controller.config.identifier != nil }) else { return }

        mainSync {
            if controller.config.isWait, !share.windows.isEmpty {
                share.waitQueue[controller.key] = controller
            } else {
                switch controller.config.mode {
                case .coexistence:
                    break
                case .removeBefore:
                    share.windows.removeAll()
                case .unique:
                    share.windows.removeAll()
                    share.waitQueue.removeAll()
                }
                let window = CLPopoverWindow(frame: UIScreen.main.bounds)
                window.backgroundColor = .clear
                window.isPenetrate = controller.config.isPenetrate
                window.windowLevel = .alert + 50
                window.rootViewController = controller
                window.makeKeyAndVisible()
                share.windows[controller.key] = window
                share.waitQueue.removeValue(forKey: controller.key)
            }
        }
    }

    /// 隐藏所有弹窗
    static func hiddenAll() {
        mainSync {
            keyWindow?.makeKeyAndVisible()
            share.waitQueue.removeAll()
            share.windows.removeAll()
            manager = nil
        }
    }

    /// 隐藏指定弹窗
    static func hidden(_ key: String) {
        share.waitQueue.removeValue(forKey: key)
        share.windows.removeValue(forKey: key)
        guard !(share.windows.isEmpty && share.waitQueue.isEmpty) else { return hiddenAll() }
        guard let lastController = share.waitQueue.values.max(by: { $0.config.priority > $1.config.priority }) else { return }
        show(lastController)
    }
}
