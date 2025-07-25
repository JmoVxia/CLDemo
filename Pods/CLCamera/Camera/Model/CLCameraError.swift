//
//  CLCameraError.swift
//  CLCamera
//
//  Created by Chen JmoVxia on 2022/1/1.
//

import UIKit

enum CLCameraError {
    case failedToInitializeCameraDevice
    case failedToInitializeMicrophoneDevice
    case cameraPermissionDenied
    case microphonePermissionDenied
    case imageNotFound
    case underlying(Error)
}

extension CLCameraError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToInitializeCameraDevice:
            "相机初始化失败"
        case .failedToInitializeMicrophoneDevice:
            "麦克风初始化失败"
        case .cameraPermissionDenied:
            "无法获取相机权限，请在“设置”中允许访问相机"
        case .microphonePermissionDenied:
            "无法获取麦克风权限，请在“设置”中允许访问麦克风"
        case .imageNotFound:
            "获取图片失败"
        case let .underlying(error):
            error.localizedDescription
        }
    }
}
