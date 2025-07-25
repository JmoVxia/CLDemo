//
//  AVCapturePhoto+Extension.swift
//  CLCarmera
//
//  Created by Chen JmoVxia on 2024/2/28.
//

import AVFoundation
import UIKit

extension AVCapturePhoto {
    func captureAsUIImage() -> UIImage? {
        guard let data = fileDataRepresentation() else { return nil }
        guard var image = CIImage(data: data) else { return nil }

        if let source = CGImageSourceCreateWithData(data as CFData, nil),
           let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any],
           let originalOrientation = metadata[kCGImagePropertyOrientation as String] as? Int32
        {
            image = image.oriented(forExifOrientation: originalOrientation)
        }

        guard let cgImage = CIContext().createCGImage(image, from: image.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
