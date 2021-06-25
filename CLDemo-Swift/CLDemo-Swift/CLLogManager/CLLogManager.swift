//
//  CLLogManager.swift
//  CL
//
//  Created by JmoVxia on 2020/6/8.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
//import DateToolsSwift

@objcMembers class CLLogManager: NSObject {
    static let shared = CLLogManager()
    private (set) var folderPath: String = String(format: "%@/%@", pathDocuments, "CLLog")
    private var logQueue: DispatchQueue = DispatchQueue(label: "CLLogManager.logQueue")
    private lazy var logFileHandle: FileHandle? = {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: folderPath) {
            try? fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        let logArray = CLLogManager.logPathArray
        if logArray.count >= 40, let lastFilePath = logArray.last, fileManager.fileExists(atPath: lastFilePath) {
            try? fileManager.removeItem(atPath: lastFilePath)
        }
        let time = Date(timeIntervalSinceNow: 0).format(with: "yyyy-MM-dd HH:mm:ss")
        //新增第0的一个文件
        let currentFilePath = "\(folderPath)/\(time).log"
        fileManager.createFile(atPath: currentFilePath, contents: nil, attributes: nil)
        let fileHandle = FileHandle(forWritingAtPath: currentFilePath)
        fileHandle?.truncateFile(atOffset: 0)
        return fileHandle
    }()
    ///log路径数组
    class var logPathArray: [String] {
        return findAllFile(type: "log", folderPath: shared.folderPath).sorted { (path1, path2) -> Bool in
            let date1 = Date(dateString: (path1.lastPathComponent as NSString).deletingPathExtension, format: "yyyy-MM-dd HH:mm:ss")
            let date2 = Date(dateString: (path2.lastPathComponent as NSString).deletingPathExtension, format: "yyyy-MM-dd HH:mm:ss")
            return date1.isLater(than: date2)
        }
    }
    private override init() {
        super.init()
    }
}
extension CLLogManager {
    class func CLLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let time = Date().format(with: "yyyy-MM-dd HH:mm:ss.SSS")
        let logMessage = "\(time) " + "\(file.lastPathComponent) " + "\(function) " + "\(line)\n" + message
        shared.logQueue.async {
            print("\(logMessage)\n\n\n")
            guard let output = shared.logFileHandle else {return}
            let text = logMessage.aes128Encrypt + "\n"
            if let textData = text.data(using: .utf8) {
                output.write(textData)
            }
        }
    }
}
