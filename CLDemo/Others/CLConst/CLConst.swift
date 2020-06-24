//
//  swift
//  CKD
//
//  Created by JmoVxia on 2020/2/25.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

///屏幕宽
func cl_screenWidth() -> CGFloat {
    return UIScreen.main.bounds.size.width
}
///屏幕高
func cl_screenHeight() -> CGFloat {
    return UIScreen.main.bounds.size.height
}
///状态栏高度
func cl_statusBarHeight() -> CGFloat {
    return UIApplication.shared.statusBarFrame.size.height
}
///按照iPhone6宽度等比例缩放
func cl_scale_iphone6_width(_ width: CGFloat, pt:Bool = true) -> CGFloat {
    return width / 750 * cl_screenWidth() * (pt ? 2.0 : 1.0)
}
///按照iPhone6高度等比例缩放
func cl_scale_iphone6_height(_ height: CGFloat, pt:Bool = true) -> CGFloat {
    return height / 1334 * cl_screenHeight() * (pt ? 2.0 : 1.0)
}
///安全区域
func cl_safeAreaInsets() -> UIEdgeInsets {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
    }else {
        return UIEdgeInsets.zero
    }
}
///是否是ipad
func cl_iPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
}
///判断iPhone4
func cl_iPhone4() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 960).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhone5系列
func cl_iPhone5() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhone6系列
func cl_iPhone6() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhone6Plus
func cl_iPhone6Plus() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断cl_iPhoneXScreen
func cl_iPhoneX() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhoneXr
func cl_iPhoneXr() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 828, height: 1792).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhoneXs
func cl_iPhoneXs() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断iPhoneXsMax
func cl_iPhoneXsMax() -> Bool {
    return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2688).equalTo((UIScreen.main.currentMode?.size)!) : false)
}
///判断cl_iPhoneXScreen系列
func cl_iPhoneXScreen() -> Bool {
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

///时间戳格式化
func timeStampFormat(with timeStamp:String, format: String) -> String {
    let timeInterval:TimeInterval = TimeInterval(timeStamp) ?? TimeInterval(0)
    let date = Date(timeIntervalSince1970: timeInterval)
    return date.format(with: format, locale: Locale(identifier: "zh_CN"))
}

///秒级时间戳
func timeStamp() -> Int {
    return Date().timeStamp
}
///毫秒级时间戳
func milliStamp() -> Int {
    return Date().milliStamp
}
///纳秒级时间戳
func nanosecondStamp() -> Int {
    return Date().nanosecondStamp
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
