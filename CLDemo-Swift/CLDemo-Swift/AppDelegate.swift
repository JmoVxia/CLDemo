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
        let tabBarController = CLTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}
extension AppDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }), keyWindow.isKind(of: CLPopupManagerWindow.self) {
            return keyWindow.rootViewController?.supportedInterfaceOrientations ?? .all
        }else {
            return .all
        }
    }
}

