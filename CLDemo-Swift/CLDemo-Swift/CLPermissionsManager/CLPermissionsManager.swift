//
//  CLPermissionsManager.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/6/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import AVFoundation
import Photos
import UIKit

class CLPermissionsManager: NSObject {
    enum CLPermissionType: Int {
        /// 相机
        case camera = 0
        /// 相册
        case photoLibrary = 1
        /// 麦克风
        case microphone = 2
    }

    /// 是否允许权限
    class func isAllowed(_ permission: CLPermissionType) -> Bool {
        let manager = getManagerForPermission(permission)
        return manager.isAuthorized
    }

    /// 是否拒绝权限
    class func isDenied(_ permission: CLPermissionType) -> Bool {
        let manager = getManagerForPermission(permission)
        return manager.isDenied
    }

    /// 请求权限
    static func request(_ permission: CLPermissionType, completion: ((CLPermissionStatus) -> Void)? = nil) {
        let manager = getManagerForPermission(permission)
        manager.request { status in
            DispatchQueue.main.async {
                completion?(status)
            }
        }
    }

    static func request(_ permissions: [CLPermissionType], completion: ((CLPermissionStatus) -> Void)? = nil) {
        request(permissions[0]) { status in
            guard status.isAuthorized, permissions.count > 1 else {
                completion?(status)
                return
            }
            var temp = permissions
            temp.remove(at: 0)
            request(temp, completion: completion)
        }
    }
}

extension CLPermissionsManager {
    private class func getManagerForPermission(_ permission: CLPermissionType) -> CLPermissionProtocol {
        switch permission {
        case .camera:
            CLCamera()
        case .photoLibrary:
            CLPhotoLibrary()
        case .microphone:
            CLMicrophone()
        }
    }
}
