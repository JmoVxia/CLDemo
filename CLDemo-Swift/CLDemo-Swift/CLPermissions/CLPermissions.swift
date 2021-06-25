//
//  CLPermissions.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/6/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import UIKit
import AVFoundation
import UserNotifications
import Photos
import MapKit
import EventKit
import Contacts
import Speech
import MediaPlayer
import HealthKit
import CoreMotion

class CLPermissions: NSObject {
    enum CLPermissionType: Int {
        ///相机
        case camera = 0
        ///相册
        case photoLibrary = 1
        ///麦克风
        case microphone = 2
    }
    ///是否允许权限
    class func isAllowed(_ permission: CLPermissionType) -> Bool {
        let manager = getManagerForPermission(permission)
        return manager.isAuthorized
    }
    ///是否拒绝权限
    class func isDenied(_ permission: CLPermissionType) -> Bool {
        let manager = getManagerForPermission(permission)
        return manager.isDenied
    }
    ///请求权限
    class func request(_ permission: CLPermissionType, with сompletionCallback: ((CLAuthorizationStatus)->())? = nil) {
        let manager = getManagerForPermission(permission)
        manager.request { (status) in
            DispatchQueue.main.async {
                сompletionCallback?(status)
            }
        }
    }
}
extension CLPermissions {
    private class func getManagerForPermission(_ permission: CLPermissionType) -> CLPermissionInterface {
        switch permission {
        case .camera:
            return CLCameraPermission()
        case .photoLibrary:
            return CLPhotoLibraryPermission()
        case .microphone:
            return CLMicrophonePermission()
        }
    }
}
