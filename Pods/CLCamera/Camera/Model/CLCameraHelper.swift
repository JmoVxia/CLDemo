//
//  CLCameraHelper.swift
//  CLCamera
//
//  Created by Chen JmoVxia on 2024/2/26.
//

import AVFoundation
import UIKit

protocol CLCameraHelperDelegate: AnyObject {
    func cameraHelper(_ helper: CLCameraHelper, didOccurError error: CLCameraError)
    func cameraHelper(_ helper: CLCameraHelper, didFinishTakingPhoto photo: UIImage)
    func cameraHelper(_ helper: CLCameraHelper, didFinishTakingVideo url: URL)
}

extension CLCameraHelperDelegate {
    func cameraHelper(_ helper: CLCameraHelper, didOccurError error: CLCameraError) {}
    func cameraHelper(_ helper: CLCameraHelper, didFinishTakingPhoto photo: UIImage) {}
    func cameraHelper(_ helper: CLCameraHelper, didFinishTakingVideo url: URL) {}
}

class CLCameraHelper: NSObject {
    init(config: CLCameraConfig) {
        self.config = config
        super.init()
        initializeCameraSession()
    }

    deinit {
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    weak var delegate: CLCameraHelperDelegate?

    private let orientation = CLCameraOrientation()
    private let sessionQueue = DispatchQueue(label: "com.Camera.Session")
    private let movieFileOutputQueue = DispatchQueue(label: "com.Camera.Movie")
    private let photoOutputQueue = DispatchQueue(label: "com.Camera.Photo")
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let movieFileOutput = AVCaptureMovieFileOutput()
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var audioDeviceInput: AVCaptureDeviceInput?
    private var videoCurrentZoom = 1.0
    private var currentOrientation = CLCameraOrientation.CaptureOrientation.up
    private var config: CLCameraConfig
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resizeAspectFill
        layer.frame = .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.size.height - 130 - safeAreaInsets.bottom))
        return layer
    }()

    /// 切换到主线程同步执行
    @discardableResult private func mainSync<T>(execute block: () -> T) -> T {
        guard !Thread.isMainThread else { return block() }
        return DispatchQueue.main.sync { block() }
    }

    /// 安全区域
    private var safeAreaInsets: UIEdgeInsets { mainSync { keyWindow?.safeAreaInsets ?? .zero } }

    /// keyWindow
    private var keyWindow: UIWindow? {
        mainSync {
            if #available(iOS 13.0, *) {
                UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap(\.windows)
                    .first { $0.isKeyWindow }
            } else {
                UIApplication.shared.keyWindow
            }
        }
    }
}

private extension CLCameraHelper {
    func initializeCameraSession() {
        try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        orientation.delegate = self
        sessionQueue.async { [weak self] in
            self?.setupCapture()
            self?.startRunning()
        }
    }

    func setupCapture() {
        captureSession.beginConfiguration()

        let sessionPreset = config.sessionPreset.avSessionPreset
        if captureSession.canSetSessionPreset(sessionPreset) {
            captureSession.sessionPreset = sessionPreset
        } else {
            captureSession.sessionPreset = CLCameraSessionPreset.hd1920x1080.avSessionPreset
        }

        setupDataOutput()
        setupCameraDevice(position: .back)
        setupMicrophoneDevice()

        captureSession.commitConfiguration()
    }

    func setupDataOutput() {
        photoOutput.isHighResolutionCaptureEnabled = true
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }

        movieFileOutput.movieFragmentInterval = .invalid
        if captureSession.canAddOutput(movieFileOutput) {
            captureSession.addOutput(movieFileOutput)
        }
    }

    func setupCameraDevice(position: AVCaptureDevice.Position) {
        if let videoDeviceInput = self.videoDeviceInput {
            captureSession.removeInput(videoDeviceInput)
        }
        guard let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                 mediaType: .video,
                                                                 position: position).devices.first,
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice)
        else {
            delegate?.cameraHelper(self, didOccurError: .failedToInitializeCameraDevice)
            return
        }
        self.videoDeviceInput = videoDeviceInput

        if captureSession.canAddInput(videoDeviceInput) {
            captureSession.addInput(videoDeviceInput)
        }

        try? videoDevice.lockForConfiguration()

        videoDevice.isSubjectAreaChangeMonitoringEnabled = true
        if videoDevice.isSmoothAutoFocusSupported {
            videoDevice.isSmoothAutoFocusEnabled = true
        }

        if let availableActiveFormat = videoDevice.bestMatchingFormat(for: config) {
            videoDevice.activeFormat = availableActiveFormat
            let frameDuration = CMTime(value: 1, timescale: CMTimeScale(config.videoFrameRate))
            videoDevice.activeVideoMinFrameDuration = frameDuration
            videoDevice.activeVideoMaxFrameDuration = frameDuration
        }

        if let connection = movieFileOutput.connection(with: .video) {
            let stabilizationMode = config.videoStabilizationMode.avPreferredVideoStabilizationMode
            connection.preferredVideoStabilizationMode = stabilizationMode
            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = position == .front
            }
        }

        if let connection = photoOutput.connection(with: .video),
           connection.isVideoMirroringSupported
        {
            connection.isVideoMirrored = position == .front
        }

        videoDevice.unlockForConfiguration()
    }

    func setupMicrophoneDevice() {
        guard let audioDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone],
                                                                 mediaType: .audio,
                                                                 position: .unspecified).devices.first,
            let audioDeviceInput = try? AVCaptureDeviceInput(device: audioDevice)
        else {
            delegate?.cameraHelper(self, didOccurError: .failedToInitializeMicrophoneDevice)
            return
        }
        self.audioDeviceInput = audioDeviceInput
        if captureSession.canAddInput(audioDeviceInput) {
            captureSession.addInput(audioDeviceInput)
        }
    }

    func lockVideoDeviceForConfiguration(_ closure: (AVCaptureDevice) -> Void) {
        guard let videoDeviceInput else { return }
        let captureDevice = videoDeviceInput.device
        try? captureDevice.lockForConfiguration()
        closure(captureDevice)
        captureDevice.unlockForConfiguration()
    }
}

extension CLCameraHelper {
    func startRunning() {
        orientation.startDeviceMotionUpdates()
        sessionQueue.async { [weak self] in
            guard let self, !captureSession.isRunning else { return }
            captureSession.startRunning()
            zoom(1.0)
        }
    }

    func stopRunning() {
        orientation.stopDeviceMotionUpdates()
        sessionQueue.async { [weak self] in
            guard let self, captureSession.isRunning else { return }
            captureSession.stopRunning()
        }
    }
}

extension CLCameraHelper {
    func setupPreviewLayer(to superView: UIView) {
        superView.layer.addSublayer(previewLayer)
    }
}

extension CLCameraHelper {
    func capturePhoto() {
        photoOutputQueue.async { [weak self] in
            guard let self else { return }
            let settings = AVCapturePhotoSettings()
            settings.flashMode = config.flashMode.avFlashMode
            settings.isAutoStillImageStabilizationEnabled = photoOutput.isStillImageStabilizationSupported
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }

    func startRecordingVideo() {
        func createCaptureVideoPath(fileType: CLCameraVideoFileType) -> String {
            let directoryPath = NSTemporaryDirectory() + "CLCamera/" + "Video" + "/"
            if !FileManager.default.fileExists(atPath: directoryPath) {
                try? FileManager.default.createDirectory(at: URL(fileURLWithPath: directoryPath),
                                                         withIntermediateDirectories: true,
                                                         attributes: nil)
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-DD_HH-MM-SS.SSS"
            return directoryPath + dateFormatter.string(from: Date()) + fileType.suffix
        }
        movieFileOutputQueue.async { [weak self] in
            guard let self else { return }
            guard let connection = movieFileOutput.connection(with: .video) else { return }
            let videoPath = createCaptureVideoPath(fileType: config.videoFileType)
            let fileUrl = URL(fileURLWithPath: videoPath)
            connection.videoOrientation = currentOrientation.captureVideoOrientation
            movieFileOutput.startRecording(to: fileUrl, recordingDelegate: self)
        }
    }

    func stopRecordingVideo() {
        CLLoadingHUD.showLoading()
        movieFileOutputQueue.async { [weak self] in
            self?.movieFileOutput.stopRecording()
        }
    }
}

extension CLCameraHelper {
    func switchCamera() {
        if movieFileOutput.isRecording { return }

        guard let videoDeviceInput else { return }
        let currentPosition = videoDeviceInput.device.position
        var toChangePosition = AVCaptureDevice.Position.front
        if currentPosition == .front {
            toChangePosition = .back
        }

        sessionQueue.async { [weak self] in
            self?.captureSession.beginConfiguration()
            self?.setupCameraDevice(position: toChangePosition)
            self?.captureSession.commitConfiguration()
        }
    }

    func prepareForZoom() {
        guard let videoDeviceInput else { return }
        videoCurrentZoom = Double(videoDeviceInput.device.videoZoomFactor)
    }

    func focusAt(_ point: CGPoint) {
        lockVideoDeviceForConfiguration { [weak self] device in
            guard let self else { return }
            let cameraPoint = previewLayer.captureDevicePointConverted(fromLayerPoint: point)

            if device.isFocusModeSupported(.continuousAutoFocus) {
                device.focusMode = .continuousAutoFocus
            }
            if device.isFocusPointOfInterestSupported {
                device.focusPointOfInterest = cameraPoint
            }
            if device.isExposurePointOfInterestSupported {
                device.exposurePointOfInterest = cameraPoint
            }
            if device.isExposureModeSupported(.continuousAutoExposure) {
                device.exposureMode = .continuousAutoExposure
            }
        }
    }

    func zoom(_ multiple: Double) {
        guard let videoDeviceInput else { return }
        let videoMaxZoomFactor = min(5, videoDeviceInput.device.activeFormat.videoMaxZoomFactor)
        let toZoomFactor = max(1, videoCurrentZoom * multiple)
        let finalZoomFactor = min(toZoomFactor, videoMaxZoomFactor)
        lockVideoDeviceForConfiguration { device in
            device.videoZoomFactor = CGFloat(finalZoomFactor)
        }
    }
}

extension CLCameraHelper: CLCameraOrientationDelegate {
    func captureOrientation(_ deviceOrientation: CLCameraOrientation, didUpdateOrientation orientation: CLCameraOrientation.CaptureOrientation) {
        currentOrientation = orientation
        print(orientation)
    }
}

extension CLCameraHelper: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            delegate?.cameraHelper(self, didOccurError: .underlying(error))
        } else if let image = photo.captureAsUIImage()?.rotated(by: currentOrientation.imageOrientation) {
            delegate?.cameraHelper(self, didFinishTakingPhoto: image)
        } else {
            delegate?.cameraHelper(self, didOccurError: .imageNotFound)
        }
    }
}

extension CLCameraHelper: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        CLLoadingHUD.hideLoading()
        DispatchQueue.main.async {
            if let error {
                self.delegate?.cameraHelper(self, didOccurError: .underlying(error))
            } else {
                self.delegate?.cameraHelper(self, didFinishTakingVideo: outputFileURL)
            }
        }
    }
}
