//
//  swift
//  CL
//
//  Created by JmoVxia on 2020/2/25.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

///屏幕宽
func screenWidth() -> CGFloat {
    return UIScreen.main.bounds.size.width
}
///屏幕高
func screenHeight() -> CGFloat {
    return UIScreen.main.bounds.size.height
}
///状态栏高度
func statusBarHeight() -> CGFloat {
    return UIApplication.shared.statusBarFrame.size.height
}
///安全区域
func safeAreaEdgeInsets() -> UIEdgeInsets {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    }else {
        return UIEdgeInsets.zero
    }
}
///是否是ipad
func isIPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
}
///判断iPhone4
func isIPhone4() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 960).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhone5系列
func isIPhone5() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhone6系列
func isIPhone6() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhone6Plus
func isIPhone6Plus() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断cl_iPhoneXScreen
func isIPhoneX() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhoneXr
func isIPhoneXr() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 828, height: 1792).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhoneXs
func isIPhoneXs() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhoneXsMax
func isIPhoneXsMax() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2688).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhoneXScreen系列
func isIPhoneXScreen() -> Bool {
    var iPhoneXScreen: Bool = false
    if #available(iOS 11.0, *), let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets {
        iPhoneXScreen = safeAreaInsets.bottom > 0.0
    }
    return iPhoneXScreen
}

///PingFang-SC-Bold字体
func PingFangSCBold(_ size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Medium", size: size) ?? UIFont.boldSystemFont(ofSize: size)
}
///PingFang-SC-Medium字体
func PingFangSCMedium(_ size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue", size: size) ?? UIFont.systemFont(ofSize: size)
}

///秒级时间戳格式化
func timeStampFormat(with timeStamp:String, format: String) -> String {
    let timeInterval: TimeInterval = TimeInterval(timeStamp.int)
    let date = Date(timeIntervalSince1970: timeInterval)
    return date.format(with: format, locale: Locale(identifier: "zh_CN"))
}
///毫秒级时间戳格式化
func milliStampFormat(with timeStamp:String, format: String) -> String {
    let timeInterval: TimeInterval = TimeInterval(timeStamp.int) / 1000.0
    let date = Date(timeIntervalSince1970: timeInterval)
    return date.format(with: format, locale: Locale(identifier: "zh_CN"))
}


///秒级时间戳
func timeStamp() -> Int64 {
    return Int64(Date().timeStamp)
}
///毫秒级时间戳
func milliStamp() -> Int64 {
    return Int64(Date().milliStamp)
}
///纳秒级时间戳
func nanosecondStamp() -> Int64 {
    return Int64(Date().nanosecondStamp)
}
///秒级时间戳
func timeStampString() -> String {
    return Date().timeStampString
}
///毫秒级时间戳
func milliStampString() -> String {
    return Date().milliStampString
}
///纳秒级时间戳
func nanosecondStampString() -> String {
    return Date().nanosecondStampString
}
///日志打印，会加入日志中
func CLLog (_ message: String, file:String = #file, function:String = #function, line:Int = #line) {
    CLLogManager.CLLog(message, file: file, function: function, line: line)
}
///查找路径及其子路径下所有指定类型文件
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
///查找文件夹路径及其子路径下所有指定类型文件所在文件夹路径
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
///查找路径下所有空文件夹,只会查找一级目录
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
///删除指定目录下所有空文件夹
func deleteAllEmptyFolderWithPath(path: String) -> Bool {
    let manager = FileManager.default
    var isSuccess: Bool = true
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
///沙盒路径
var pathDocuments: String {
    return NSHomeDirectory() + "/Documents"
}
///根据时间生成随机字符串
var dateRandomString: String {
    let date = Date()
    let dateString: String = date.format(with: "yyyyMMddHHmmss") + date.nanosecondStampString
    return (dateString + UUID().uuidString).md5ForUpper32Bate
}

///消息毫秒级时间戳格式化
func messageTimeFormat(with timeStamp:Int64) -> String {
    let timeInterval: TimeInterval = TimeInterval(Double(timeStamp) / 1000.0)
    let date = Date(timeIntervalSince1970: timeInterval)
    var time = date.format(with: "yyyy-MM-dd HH:mm", locale: Locale(identifier: "zh_CN"))
    if date.isToday {
        time = date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
    }else if date.isYesterday {
        time = "昨天" + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
    }else if date.weeksAgo == 0 {
        switch date.weekday {
        case 1:
            time = "星期日" + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
            break
        case 2:
            time = "星期一" + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
            break
        case 3:
            time = "星期二" + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
            break
        case 4:
            time = "星期三" + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
            break
        case 5:
            time = "星期四" + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
            break
        case 6:
            time = "星期五" + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
            break
        case 7:
            time = "星期六" + date.format(with: "HH:mm", locale: Locale(identifier: "zh_CN"))
            break
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
func calculateScaleSize(imageSize: CGSize, maxSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width * 0.45, height: UIScreen.main.bounds.size.width * 0.45), minSize: CGSize = CGSize(width: 90, height: 90)) -> CGSize {
    let maxWidth = maxSize.width
    let maxHeight = maxSize.height
    let minWidth = minSize.width
    let minHeight = minSize.height
    
    let imageWidth = imageSize.width
    let imageHeight = imageSize.height
    
    let imageRatio = imageHeight / imageWidth
    let minRatio = minHeight / maxWidth
    let maxRatio = maxHeight / minWidth
    
    if imageRatio >= maxRatio {
        return CGSize(width: minWidth, height: maxHeight)
    }else if imageRatio <= minRatio {
        return CGSize(width: maxWidth, height: minHeight)
    }else {
        let maxRatio = maxHeight / maxWidth
        let minRatio = minHeight / minWidth
        if imageRatio >= minRatio && imageHeight > maxHeight {
            return CGSize(width: imageWidth / imageHeight * maxHeight, height: maxHeight)
        }else if imageRatio < maxRatio && imageWidth > maxWidth {
            return CGSize(width: maxWidth, height: imageHeight / imageWidth * maxWidth)
        }else if imageRatio >= maxRatio && imageWidth < minWidth {
            return CGSize(width: minWidth, height: imageHeight / imageWidth * minWidth)
        }else if imageRatio < maxRatio && imageHeight < minHeight {
            return CGSize(width: imageWidth / imageHeight * minHeight, height: minHeight)
        }else {
            return imageSize
        }
    }
}
/// 打开APP权限设置
func openSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:])
}
