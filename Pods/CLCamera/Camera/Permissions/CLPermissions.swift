//
//  CLPermissions.swift
//  CLCamera
//
//  Created by JmoVxia on 2020/6/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import AVFoundation
import Photos
import UIKit

class CLPermissions: NSObject {
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
    static func request(_ permission: CLPermissionType, completion: ((CLAuthorizationStatus) -> Void)? = nil) {
        let manager = getManagerForPermission(permission)
        manager.request { status in
            DispatchQueue.main.async {
                completion?(status)
            }
        }
    }

    static func request(_ permissions: [CLPermissionType], completion: ((CLAuthorizationStatus) -> Void)? = nil) {
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

extension CLPermissions {
    private class func getManagerForPermission(_ permission: CLPermissionType) -> CLPermissionInterface {
        switch permission {
        case .camera:
            CLCameraPermission()
        case .photoLibrary:
            CLPhotoLibraryPermission()
        case .microphone:
            CLMicrophonePermission()
        }
    }
}
