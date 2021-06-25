//
//  CLBreakPointResumeManager.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/6/10.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit
import CryptoSwift

extension CLBreakPointResumeManager {
    enum DownloadError: Error {
        ///下载中
        case downloading
        ///不是HTTPURLResponse类型
        case notHTTPURLResponse
        ///throws错误
        case `throws`(Error)
        ///状态码错误
        case statusCode(Int)
        ///下载错误
        case download(Error)
    }
}

class CLBreakPointResumeManager: NSObject {
    static let shared: CLBreakPointResumeManager = CLBreakPointResumeManager()
    static let folderPath: String = NSHomeDirectory() + "/Documents/CLBreakPointResume/"
    private var operationDictionary = [String : CLBreakPointResumeOperation]()
    private lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    private lazy var operationSemap: DispatchSemaphore = {
        let semap = DispatchSemaphore(value: 0)
        semap.signal()
        return semap
    }()
    private override init() {
        super.init()
        if !FileManager.default.fileExists(atPath: CLBreakPointResumeManager.folderPath) {
            try? FileManager.default.createDirectory(atPath: CLBreakPointResumeManager.folderPath, withIntermediateDirectories: true)
        }
    }
}
extension CLBreakPointResumeManager {
    static func download(_ url: URL, progressBlock: ((CGFloat) -> ())? = nil, completionBlock: ((Result<String, DownloadError>) -> ())? = nil) {
        let completion = { result in
            DispatchQueue.main.async {
                completionBlock?(result)
            }
        }
        
        guard operation(url.absoluteString) == nil else {
            completion(.failure(.downloading))
            return
        }
        let fileAttribute = fileAttribute(url)
        guard !isDownloaded(url).0 else {
            progressBlock?(1)
            completion(.success(fileAttribute.path))
            return
        }
        
        let operation = CLBreakPointResumeOperation(url: url, path: fileAttribute.path, currentBytes: fileAttribute.currentBytes)
        operation.progressBlock = progressBlock
        operation.completionBlock = {
            if let error = operation.error {
                completion(.failure(error))
            }else {
                completion(.success(fileAttribute.path))
            }
            removeValue(url.absoluteString)
        }
        shared.queue.addOperation(operation)
        setOperation(operation, for: url.absoluteString)
    }
    static func cancel(_ url: URL) {
        guard let operation = operation(url.absoluteString),
              !operation.isCancelled
        else {
            return
        }
        operation.cancel()
    }
    static func delete(_ url: URL) throws {
        cancel(url)
        try FileManager.default.removeItem(atPath: filePath(url))
    }
    static func deleteAll() throws {
        for operation in shared.operationDictionary.values where !operation.isCancelled {
            operation.cancel()
        }
        try FileManager.default.removeItem(atPath: folderPath)
    }
}
private extension CLBreakPointResumeManager {
    static func operation(_ value: String) -> CLBreakPointResumeOperation? {
        shared.operationSemap.wait()
        let operation = shared.operationDictionary[value]
        shared.operationSemap.signal()
        return operation
    }
    static func setOperation(_ value: CLBreakPointResumeOperation, for key: String) {
        shared.operationSemap.wait()
        shared.operationDictionary[key] = value
        shared.operationSemap.signal()
    }
    static func removeValue(_ value: String) {
        shared.operationSemap.wait()
        shared.operationDictionary.removeValue(forKey: value)
        shared.operationSemap.signal()
    }
}
extension CLBreakPointResumeManager {
    static func isDownloaded(_ url: URL) -> (Bool, String) {
        let fileAttribute = fileAttribute(url)
        return (fileAttribute.currentBytes != 0 && fileAttribute.currentBytes == fileAttribute.totalBytes, fileAttribute.path)
    }
}
extension CLBreakPointResumeManager {
    static func fileAttribute(_ url: URL) -> (path: String, currentBytes: Int64, totalBytes: Int64) {
        return (filePath(url), fileCurrentBytes(url), fileTotalBytes(url))
    }
    static func filePath(_ url: URL) -> String {
        return folderPath + url.absoluteString.md5() + (url.pathExtension.isEmpty ? "" : ".\(url.pathExtension)")
    }
    static func fileCurrentBytes(_ url: URL) -> Int64 {
        let path = filePath(url)
        var downloadedBytes: Int64 = 0
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            let fileDict = try? fileManager.attributesOfItem(atPath: path)
            downloadedBytes = fileDict?[.size] as? Int64 ?? 0
        }
        return downloadedBytes
    }
    static func fileTotalBytes(_ url: URL) -> Int64 {
        var totalBytes : Int64 = 0
        if let sizeData = try? URL(fileURLWithPath: filePath(url)).extendedAttribute(forName: "totalBytes") {
            (sizeData as NSData).getBytes(&totalBytes, length: sizeData.count)
        }
        return totalBytes
    }
}

