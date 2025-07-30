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
        DispatchQueue.global().async {
            CLLog("APP 冷启动", level: [.message])
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
