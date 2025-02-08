//
//  CLCameraOrientation.swift
//  CLCamera
//
//  Created by Chen JmoVxia on 2024/2/27.
//

import AVFoundation
import CoreMotion
import UIKit

protocol CLCameraOrientationDelegate: AnyObject {
    func captureOrientation(_ deviceOrientation: CLCameraOrientation, didUpdateOrientation orientation: CLCameraOrientation.CaptureOrientation)
}

extension CLCameraOrientation {
    enum CaptureOrientation {
        case up
        case left
        case down
        case right

        var captureVideoOrientation: AVCaptureVideoOrientation {
            switch self {
            case .up:
                .portrait
            case .left:
                .landscapeRight
            case .down:
                .portraitUpsideDown
            case .right:
                .landscapeLeft
            }
        }

        var imageOrientation: UIImage.Orientation {
            switch self {
            case .up:
                .up
            case .left:
                .left
            case .down:
                .down
            case .right:
                .right
            }
        }
    }
}

class CLCameraOrientation: NSObject {
    weak var delegate: CLCameraOrientationDelegate?

    private var orientation = CLCameraOrientation.CaptureOrientation.up {
        didSet {
            guard orientation != oldValue else { return }
            delegate?.captureOrientation(self, didUpdateOrientation: orientation)
        }
    }

    private lazy var motionManager: CMMotionManager = {
        let manager = CMMotionManager()
        manager.deviceMotionUpdateInterval = 0.5
        return manager
    }()
}

extension CLCameraOrientation {
    func startDeviceMotionUpdates() {
        if motionManager.isDeviceMotionAvailable,
           let queue = OperationQueue.current
        {
            motionManager.startDeviceMotionUpdates(to: queue) { [weak self] motion, _ in
                guard let motion else { return }
                self?.handleDeviceMotionUpdate(motion)
            }
        }
    }

    func stopDeviceMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}

private extension CLCameraOrientation {
    func handleDeviceMotionUpdate(_ motion: CMDeviceMotion) {
        let sensitive = 0.77
        let x = motion.gravity.x
        let y = motion.gravity.y

        if y < 0, fabs(y) > sensitive {
            orientation = .up
        } else if y > sensitive {
            orientation = .down
        }
        if x < 0, fabs(x) > sensitive {
            orientation = .left
        } else if x > sensitive {
            orientation = .right
        }
    }
}
