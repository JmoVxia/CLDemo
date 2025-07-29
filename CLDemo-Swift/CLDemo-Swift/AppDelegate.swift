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
        CLLogManager.startLoggingService()
        CLLog("APP 冷启动", level: [.info])
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
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        .all
    }
}
