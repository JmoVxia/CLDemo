//
//  CLPermissionInterface.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/7/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import Photos

enum CLAuthorizationStatus {
    ///未知状态
    case unknown
    ///用户未选择
    case notDetermined
    ///用户没有权限
    case restricted
    ///拒绝
    case denied
    ///允许
    case authorized
    ///临时允许
    case provisional
    ///设备不支持
    case noSupport
    ///是否可以访问
    var isAuthorized: Bool {
        return self == .authorized || self == .provisional
    }
    ///是否不支持
    var isNoSupport: Bool {
        return self == .noSupport
    }
}

protocol CLPermissionInterface {
    ///是否允许
    var isAuthorized: Bool { get }
    ///是否拒绝
    var isDenied: Bool { get }
    ///请求权限
    func request(сompletionCallback: ((CLAuthorizationStatus)->())?)
}

/// 相册权限
struct CLPhotoLibraryPermission: CLPermissionInterface {
    var isAuthorized: Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    var isDenied: Bool {
        return PHPhotoLibrary.authorizationStatus() == .denied
    }
    func request(сompletionCallback: ((CLAuthorizationStatus)->())?) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var authorizationStatus: CLAuthorizationStatus = .unknown
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                authorizationStatus = .authorized
            case .notDetermined:
                authorizationStatus = .notDetermined
            case .restricted:
                authorizationStatus = .restricted
            case .denied:
                authorizationStatus = .denied
            default:
                authorizationStatus = .unknown
            }
            if authorizationStatus == .notDetermined {
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized {
                        authorizationStatus = .authorized
                    }else if status == .denied {
                        authorizationStatus = .denied
                    }
                    сompletionCallback?(authorizationStatus)
                }
            }else {
                сompletionCallback?(authorizationStatus)
            }
        }else {
            сompletionCallback?(.noSupport)
        }
    }
}
/// 相机权限
struct CLCameraPermission: CLPermissionInterface {
    var isAuthorized: Bool {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.authorized
    }
    var isDenied: Bool {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.denied
    }
    func request(сompletionCallback: ((CLAuthorizationStatus)->())?) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var authorizationStatus: CLAuthorizationStatus = .unknown
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                authorizationStatus = .authorized
            case .notDetermined:
                authorizationStatus = .notDetermined
            case .restricted:
                authorizationStatus = .restricted
            case .denied:
                authorizationStatus = .denied
            default:
                authorizationStatus = .unknown
            }
            if authorizationStatus == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video) { (authorized) in
                    сompletionCallback?(authorized ? .authorized : .denied)
                }
            }else {
                сompletionCallback?(authorizationStatus)
            }
        }else {
            сompletionCallback?(.noSupport)
        }
    }
}
///麦克风权限
struct CLMicrophonePermission: CLPermissionInterface {
    var isAuthorized: Bool {
        return AVAudioSession.sharedInstance().recordPermission == .granted
    }
    var isDenied: Bool {
        return AVAudioSession.sharedInstance().recordPermission == .denied
    }
    func request(сompletionCallback: ((CLAuthorizationStatus)->())?) {
        if AVAudioSession.sharedInstance().isInputAvailable {
            var authorizationStatus: CLAuthorizationStatus = .unknown
            switch AVAudioSession.sharedInstance().recordPermission {
            case .undetermined:
                authorizationStatus = .notDetermined
            case .granted:
                authorizationStatus = .authorized
            case .denied:
                authorizationStatus = .denied
            default:
                authorizationStatus = .unknown
            }
            if authorizationStatus == .notDetermined {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    сompletionCallback?(granted ? .authorized : .denied)
                }
            }else {
                сompletionCallback?(authorizationStatus)
            }
        }else {
            сompletionCallback?(.noSupport)
        }
    }
}
