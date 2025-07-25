# CLCamera

## 功能

- [x] 拍照
- [x] 视频录制

## 配置

```swift
public struct CLCameraConfig {
    // 是否允许拍摄照片
    public var allowTakingPhoto: Bool = true

    // 是否允许拍摄视频
    public var allowTakingVideo: Bool = true

    // 视频拍摄最长时长
    public var maximumVideoDuration: TimeInterval = 60

    // 拍摄闪光灯开关
    public var flashMode: CLCameraFlashMode = .auto

    // 视频拍摄格式
    public var videoFileType: CLCameraVideoFileType = .mp4

    // 视频拍摄帧率
    public var videoFrameRate: Double = 60

    // 视频拍摄预设
    public var sessionPreset: CLCameraSessionPreset = .hd1920x1080

    // 视频拍摄防抖模式
    public var videoStabilizationMode: CLCameraVideoStabilizationMode = .off
}
```

## cocoapods

```swift
pod 'CLCamera'
```

## 使用

使用参考[demo](https://github.com/JmoVxia/CLDemo)

