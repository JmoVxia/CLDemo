//
//  CLCameraEnum.swift
//  CLCamera
//
//  Created by Chen JmoVxia on 2024/2/26.
//

import AVFoundation
import UIKit

// 拍摄闪光灯选项
public enum CLCameraFlashMode {
    case auto
    case on
    case off
}

extension CLCameraFlashMode {
    var avFlashMode: AVCaptureDevice.FlashMode {
        switch self {
        case .auto: .auto
        case .on: .on
        case .off: .off
        }
    }

    var cameraFlashMode: UIImagePickerController.CameraFlashMode {
        switch self {
        case .auto: .auto
        case .on: .on
        case .off: .off
        }
    }
}

// 拍摄视频稳定配置
public enum CLCameraVideoStabilizationMode {
    case auto
    case off
    case standard
    case cinematic
    @available(iOS 13.0, *)
    case cinematicExtended
}

extension CLCameraVideoStabilizationMode {
    var avPreferredVideoStabilizationMode: AVCaptureVideoStabilizationMode {
        switch self {
        case .auto: return .auto
        case .off: return .off
        case .standard: return .standard
        case .cinematic: return .cinematic
        case .cinematicExtended:
            if #available(iOS 13.0, *) {
                return .cinematicExtended
            }
            return .auto
        }
    }
}

// 拍摄视频预设
public enum CLCameraSessionPreset {
    case cif352x288
    case vga640x480
    case hd1280x720
    case hd1920x1080
    case hd4K3840x2160
}

extension CLCameraSessionPreset {
    var avSessionPreset: AVCaptureSession.Preset {
        switch self {
        case .cif352x288: .cif352x288
        case .vga640x480: .vga640x480
        case .hd1280x720: .hd1280x720
        case .hd1920x1080: .hd1920x1080
        case .hd4K3840x2160: .hd4K3840x2160
        }
    }

    var size: CGSize {
        switch self {
        case .cif352x288: CGSize(width: 352, height: 288)
        case .vga640x480: CGSize(width: 640, height: 480)
        case .hd1280x720: CGSize(width: 1280, height: 720)
        case .hd1920x1080: CGSize(width: 1920, height: 1080)
        case .hd4K3840x2160: CGSize(width: 3840, height: 2160)
        }
    }
}

// 拍摄视频格式
public enum CLCameraVideoFileType {
    case mp4
    case mov
}

extension CLCameraVideoFileType {
    var avFileType: AVFileType {
        switch self {
        case .mov: .mov
        case .mp4: .mp4
        }
    }

    var suffix: String {
        switch self {
        case .mov: ".mov"
        case .mp4: ".mp4"
        }
    }
}
