//
//  CLLoadingHUD.swift
//  CLCamera
//
//  Created by Chen JmoVxia on 2021/12/29.
//

import UIKit

class CLLoadingHUD {
    static let shared = CLLoadingHUD()

    private var window: UIWindow?

    private weak var loadingView: CLLoadingHUDView?

    private init() {}
}

private extension CLLoadingHUD {
    static func createWindow() {
        shared.window = UIWindow(frame: UIScreen.main.bounds)
        shared.window?.backgroundColor = .clear
        shared.window?.isHidden = false

        let view = CLLoadingHUDView(frame: UIScreen.main.bounds)
        shared.window?.addSubview(view)
        shared.loadingView = view
    }
}

extension CLLoadingHUD {
    static func showLoading() {
        if shared.loadingView == nil { createWindow() }
        shared.loadingView?.showLoading()
    }

    static func showProgress(_ progress: CGFloat) {
        if shared.loadingView == nil { createWindow() }
        shared.loadingView?.showProgress(progress)
    }

    static func hideLoading() {
        shared.window = nil
    }
}
