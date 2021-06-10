//
//  AppDelegate.swift
//  demo
//
//  Created by Chen JmoVxia on 2021/6/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let tabbarController = CLTabbarController()
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
        return true
    }
}
extension AppDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let keyWindow = application.keyWindow, keyWindow.isKind(of: CLPopupManagerWindow.self) {
            return keyWindow.rootViewController?.supportedInterfaceOrientations ?? .all
        }else {
            return .all
        }
    }
}
