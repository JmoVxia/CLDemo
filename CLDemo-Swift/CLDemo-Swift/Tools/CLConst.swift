//
//  swift
//  CL
//
//  Created by JmoVxia on 2020/2/25.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import DateToolsSwift
import UIKit

/// 根据时间生成随机字符串
var dateRandomString: String { "\(nanosecondStampString)-\(UUID().uuidString)-\(TimeInterval.random(in: 0.01 ... 10000))".md5ForUpper32Bate }

/// 秒级时间戳
var timeStamp: Int64 { Date().timeStamp }

/// 毫秒级时间戳
var milliStamp: Int64 { Date().milliStamp }

/// 纳秒级时间戳
var nanosecondStamp: Int64 { Date().nanosecondStamp }

/// 秒级时间戳
var timeStampString: String { Date().timeStampString }

/// 毫秒级时间戳
var milliStampString: String { Date().milliStampString }

/// 纳秒级时间戳
var nanosecondStampString: String { Date().nanosecondStampString }

/// 屏幕宽
var screenWidth: CGFloat { UIScreen.main.bounds.size.width }

/// 屏幕高
var screenHeight: CGFloat { UIScreen.main.bounds.size.height }

/// AppDelegate
var appDelegate: AppDelegate? { mainSync { UIApplication.shared.delegate as? AppDelegate } }

/// 状态栏高度
var statusBarHeight: CGFloat {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 0 }
        guard let statusBarManager = windowScene.statusBarManager else { return 0 }
        statusBarHeight = statusBarManager.statusBarFrame.height
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}

/// 安全区域
var safeAreaEdgeInsets: UIEdgeInsets { mainSync { keyWindow?.safeAreaInsets ?? .zero } }

/// 是否是刘海屏
var isIPhoneXScreen: Bool { safeAreaEdgeInsets.bottom > 0 }

/// keyWindow
var keyWindow: UIWindow? {
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

/// 顶层控制器
var topViewController: UIViewController? {
    var controller = keyWindow?.rootViewController
    while true {
        if let presented = controller?.presentedViewController {
            controller = presented
        } else if let navController = controller as? UINavigationController {
            controller = navController.topViewController
        } else if let tabBarController = controller as? UITabBarController {
            controller = tabBarController.selectedViewController
        } else {
            break
        }
    }
    return controller
}

/// 切换到主线程同步执行
@discardableResult func mainSync<T>(execute block: () -> T) -> T {
    guard !Thread.isMainThread else { return block() }
    return DispatchQueue.main.sync { block() }
}

/// 秒级时间戳格式化
func timeStampFormat(with timeStamp: String, format: String) -> String {
    let timeInterval = TimeInterval(timeStamp.int)
    let date = Date(timeIntervalSince1970: timeInterval)
    return date.format(with: format, locale: Locale(identifier: "zh_CN"))
}

/// 毫秒级时间戳格式化
func milliStampFormat(with timeStamp: String, format: String) -> String {
    let timeInterval = TimeInterval(timeStamp.int) / 1000.0
    let date = Date(timeIntervalSince1970: timeInterval)
    return date.format(with: format, locale: Locale(identifier: "zh_CN"))
}

/// 日志打印，会加入日志中
func CLLog(_ message: String, level: CLLogLevel = .info, file: String = #file, function: String = #function, line: UInt = #line) {
    CLLogManager.CLLog(message, level: level, file: file, function: function, line: line)
}

/// 查找路径及其子路径下所有指定类型文件
func findAllFile(type: String, folderPath: String, maxCount: Int = .max) -> [String] {
    let manager = FileManager.default
    let dirEnum = manager.enumerator(atPath: folderPath)
    var fileArray = [String]()
    while let file = dirEnum?.nextObject() as? String {
        if type == file.pathExtension {
            fileArray.append("\(folderPath)/\(file)")
        }
        if fileArray.count == maxCount {
            break
        }
    }
    return fileArray
}

/// 查找文件夹路径及其子路径下所有指定类型文件所在文件夹路径
func findAllFolder(type: String, folderPath: String, maxCount: Int = .max) -> [String] {
    let manager = FileManager.default
    let dirEnum = manager.enumerator(atPath: folderPath)
    var fileArray = [String]()
    while let file = dirEnum?.nextObject() as? String {
        if type == file.pathExtension {
            let path = ("\(folderPath)/\(file)" as NSString).deletingLastPathComponent
            fileArray.append(path)
        }
        if fileArray.count == maxCount {
            break
        }
    }
    return fileArray
}

/// 查找路径下所有空文件夹,只会查找一级目录
func findAllEmptyFolder(path: String) -> [String] {
    let manager = FileManager.default
    var fileArray = [String]()
    if let fileNameListArray = try? manager.contentsOfDirectory(atPath: path) {
        for filePath in fileNameListArray {
            let completePath = "\(path)/\(filePath)"
            var isDirectory = ObjCBool(false)
            if manager.fileExists(atPath: completePath, isDirectory: &isDirectory), isDirectory.boolValue, let pathArray = try? manager.contentsOfDirectory(atPath: completePath), pathArray.isEmpty {
                fileArray.append(completePath)
            }
        }
    }
    return fileArray
}

/// 删除指定目录下所有空文件夹
func deleteAllEmptyFolderWithPath(path: String) -> Bool {
    let manager = FileManager.default
    var isSuccess = true
    if let fileNameListArray = try? manager.contentsOfDirectory(atPath: path) {
        for filePath in fileNameListArray {
            let completePath = "\(path)/\(filePath)"
            var isDirectory = ObjCBool(false)
            if manager.fileExists(atPath: completePath, isDirectory: &isDirectory), isDirectory.boolValue, let pathArray = try? manager.contentsOfDirectory(atPath: completePath), pathArray.isEmpty {
                do {
                    try manager.removeItem(atPath: completePath)
                } catch {
                    isSuccess = false
                    break
                }
            }
        }
    }
    return isSuccess
}

/// 消息毫秒级时间戳格式化
func messageTimeFormat(_ timeStamp: Int64) -> String {
    let timeInterval = TimeInterval(Double(timeStamp) / 1000.0)
    let date = Date(timeIntervalSince1970: timeInterval)
    var time = date.format(with: "yyyy-MM-dd HH:mm", locale: Locale(identifier: "zh_CN"))
    let today = Date()
    let monday = Date(year: today.year, month: today.month, day: today.day).subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: today.weekday - 2, weeks: 0, months: 0, years: 0))
    if date.isToday {
        time = date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
    } else if date.isYesterday {
        time = "昨天 " + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
    } else if Date(year: date.year, month: date.month, day: date.day).isLaterThanOrEqual(to: monday) {
        switch date.weekday {
        case 1:
            time = "星期日 " + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
        case 2:
            time = "星期一 " + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
        case 3:
            time = "星期二 " + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
        case 4:
            time = "星期三 " + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
        case 5:
            time = "星期四 " + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
        case 6:
            time = "星期五 " + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
        case 7:
            time = "星期六 " + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
        default:
            break
        }
    }
    return time
}

/// 计算缩放后的大小
/// - Parameters:
///   - imageSize: 图片原始大小
///   - maxSize: 最大范围
///   - minSize: 最小范围
/// - Returns: 缩放后的大小
func calculateScaleSize(size: CGSize, maxSize: CGSize? = nil, minSize: CGSize? = nil) -> CGSize {
    let maxWidth = maxSize?.width ?? screenWidth * 0.45
    let maxHeight = maxSize?.height ?? screenWidth * 0.45
    let minWidth = minSize?.width ?? 60
    let minHeight = minSize?.height ?? 60

    guard size.width > 0, size.height > 0 else {
        return CGSize.zero
    }

    let imageRatio = size.height / size.width
    let maxRatio = maxHeight / maxWidth
    let minRatio = minHeight / minWidth

    if imageRatio >= (maxHeight / minWidth) {
        return CGSize(width: minWidth, height: maxHeight)
    } else if imageRatio <= (minHeight / maxWidth) {
        return CGSize(width: maxWidth, height: minHeight)
    } else if imageRatio >= minRatio, size.height > maxHeight {
        return CGSize(width: size.width / size.height * maxHeight, height: maxHeight)
    } else if imageRatio < maxRatio, size.width > maxWidth {
        return CGSize(width: maxWidth, height: size.height / size.width * maxWidth)
    } else if imageRatio >= maxRatio, size.width < minWidth {
        return CGSize(width: minWidth, height: size.height / size.width * minWidth)
    } else if imageRatio < maxRatio, size.height < minHeight {
        return CGSize(width: size.width / size.height * minHeight, height: minHeight)
    } else {
        return size
    }
}

/// 拨打电话
func callPhone(_ phone: String) {
    guard !phone.isEmpty else { return }
    guard let urls = URL(string: ("tel://" + phone).replacingOccurrences(of: " ", with: "", options: .literal, range: nil)) else { return }
    // 去掉空格-不然有些电话号码会使 URL 报 nil
    DispatchQueue.main.async {
        UIApplication.shared.open(urls, options: [:], completionHandler: nil)
    }
}

/// 打开APP权限设置
func openSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    DispatchQueue.main.async {
        UIApplication.shared.open(url, options: [:])
    }
}

/// 关闭键盘
func closeKeyboard() {
    keyWindow?.endEditing(true)
}
