//
//  AVCaptureDevice+Extension.swift
//  CLCarmera
//
//  Created by Chen JmoVxia on 2024/2/27.
//

import AVFoundation

extension AVCaptureDevice {
    func bestMatchingFormat(for cameraConfig: CLCameraConfig) -> AVCaptureDevice.Format? {
        let compatibleFormats = formats.filter { format in
            let formatDimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            let presetDimensions = cameraConfig.sessionPreset.size

            let hasMatchingSize = CGFloat(formatDimensions.width) == presetDimensions.width &&
                CGFloat(formatDimensions.height) == presetDimensions.height

            let supportsDesiredFrameRate = format.videoSupportedFrameRateRanges.contains {
                $0.maxFrameRate >= cameraConfig.videoFrameRate
            }

            let desiredStabilizationMode = cameraConfig.videoStabilizationMode.avPreferredVideoStabilizationMode
            let supportsStabilizationMode = format.isVideoStabilizationModeSupported(desiredStabilizationMode)

            return hasMatchingSize && supportsDesiredFrameRate && supportsStabilizationMode
        }
        return compatibleFormats.last
    }
}
