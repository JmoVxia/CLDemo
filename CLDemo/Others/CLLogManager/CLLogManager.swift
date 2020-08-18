//
//  CLLogManager.swift
//  CL
//
//  Created by JmoVxia on 2020/6/8.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

@objcMembers class CLLogManager: NSObject {
    static let shared = CLLogManager()
    private (set) var folderPath: String = String(format: "%@/%@", pathDocuments, "CLLogManager.folderPath".md5ForUpper32Bate)
    private var logQueue: DispatchQueue = DispatchQueue(label: "CLLogManager.logQueue")
    private lazy var logFileHandle: FileHandle? = {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: folderPath) {
            try? FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        let currentFilePath =  "\(folderPath)/application-0.log"
        let oldestFilePath = "\(folderPath)/application-60.log"
        if fileManager.fileExists(atPath: oldestFilePath) {
            try? fileManager.removeItem(atPath: oldestFilePath)
        }
        //遍历文件，将文件编号往后移动，新增第0的一个文件
        var i = 60 - 1
        while i >= 0 {
            let filePath = "\(folderPath)/application-\(i).log"
            let nextFilePath = "\(folderPath)/application-\(i + 1).log"
            if fileManager.fileExists(atPath: filePath) {
                try? fileManager.moveItem(atPath: filePath, toPath: nextFilePath)
            }
            i -= 1
        }
        fileManager.createFile(atPath: currentFilePath, contents: nil, attributes: nil)
        let fileHandle = FileHandle(forWritingAtPath: currentFilePath)
        fileHandle?.truncateFile(atOffset: 0)
        return fileHandle
    }()
    ///log路径数组
    class var logPathArray: [String] {
        return findAllFile(type: "log", folderPath: shared.folderPath).sorted { (path1, path2) -> Bool in
            let ietm1 = path1.lastPathComponent.firstMatch("(?<=\\-).*?(?=\\.)")?.int ?? 0
            let ietm2 = path2.lastPathComponent.firstMatch("(?<=\\-).*?(?=\\.)")?.int ?? 0
            return ietm1 < ietm2
        }
    }
    private override init() {
        super.init()
    }
}
extension CLLogManager {
    class func CLLogMessage(_ message: String) {
        let time = Date().format(with: "yyyy-MM-dd HH:mm:ss.SSS")
        let logMessage = "\(time)\n" + message + "\n\n"
        print("\(logMessage)")
        shared.logQueue.async {
            guard let output = shared.logFileHandle else {return}
            let text = logMessage
            if let textData = text.data(using: .utf8) {
                output.write(textData)
            }
        }
    }
    class func CLLog(_ message: String, file:String = #file, function:String = #function,
    line:Int = #line) {
        let time = Date().format(with: "yyyy-MM-dd HH:mm:ss.SSS")
        let logMessage = "\(time)\n" + "\(file.lastPathComponent) " + "\(function) " + "\(line)\n" + message + "\n\n"
        print("\(logMessage)")
        shared.logQueue.async {
            guard let output = shared.logFileHandle else {return}
            let text = logMessage
            if let textData = text.data(using: .utf8) {
                output.write(textData)
            }
        }
    }
}
