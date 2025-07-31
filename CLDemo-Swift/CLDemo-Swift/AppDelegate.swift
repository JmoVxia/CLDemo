//
//  AppDelegate.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/6/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CLLogManager.start()

        CLLog("APP 冷启动", level: [.message])
        DispatchQueue.global().async {
            CLLog("""
                在 Vue 3 的开发中，随着应用变得越来越复杂，响应式状态管理成为了不可或缺的一部分。尤其是当你的 state 对象越来越庞大时，你可能只关心其中某些字段的变化。这时，传统的 watch 和 computed API 在使用上可能显得有些繁琐且不够灵活。
                为了帮助开发者更高效地监听和响应字段的变化，我们推出了一个全新的 Vue 3 自定义 Hook —— useWatchFields。这个 Hook 可以让你灵活地监听 state 中的某些指定字段变化，并且不依赖于任何外部库，完全通过 Vue 内置的 API 来实现事件的管理。
                为什么使用 useWatchFields？
                当你在开发中只对部分字段的变化感兴趣时，往往需要为每个字段单独设置 watch，但这样做不仅代码冗长，而且不够灵活。useWatchFields 可以帮助你精确监听特定字段的变化，并自动将变化的前后值传递给回调函数。
                如何使用 useWatchFields？
                假设你有一个包含多个字段的 state 对象，并且你只关心其中某些字段的变化，例如 name 和 age 字段。使用 useWatchFields 后，你可以像下面这样轻松实现：
                """
            )
        }
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = CLTheme.mode.style
        }
        let tabBarController = CLTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    func applicationWillResignActive(_: UIApplication) {
        CLLog("APP 将要变为非活跃状态", level: [.message, .im])
    }

    func applicationDidBecomeActive(_: UIApplication) {
        CLLog("APP 变为活跃状态", level: [.message, .im])
    }

    func applicationWillEnterForeground(_: UIApplication) {
        CLLog("APP 将要从后台返回", level: [.message, .im])
    }

    func applicationDidEnterBackground(_: UIApplication) {
        CLLog("APP 进入后台", level: [.message, .im])
    }

    func applicationWillTerminate(_: UIApplication) {
        CLLog("APP 将要被杀死", level: [.message, .im])
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        .all
    }
}
