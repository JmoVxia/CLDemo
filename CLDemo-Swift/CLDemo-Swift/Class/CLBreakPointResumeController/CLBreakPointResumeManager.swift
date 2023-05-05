//
//  CLBreakPointResumeManager.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/6/10.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import CryptoSwift
import UIKit

extension CLBreakPointResumeManager {
    enum DownloadError: Error {
        /// 下载中
        case downloading
        /// 不是HTTPURLResponse类型
        case notHTTPURLResponse
        /// throws错误
        case `throws`(Error)
        /// 状态码错误
        case statusCode(Int)
        /// 下载错误
        case download(Error)
    }
}

class CLBreakPointResumeManager: NSObject {
    static let shared: CLBreakPointResumeManager = .init()
    static let folderPath: String = NSHomeDirectory() + "/Documents/CLBreakPointResume/"
    private var operationDictionary = [String: CLBreakPointResumeOperation]()
    private lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }()

    private lazy var semaphore: DispatchSemaphore = {
        let semap = DispatchSemaphore(value: 0)
        semap.signal()
        return semap
    }()

    private var progressSet = CLSafeArrayDictionary<String, (_ url: URL, _ progress: CGFloat) -> Void>()

    private var completionsSet = CLSafeArrayDictionary<String, (Result<String, DownloadError>) -> Void>()

    override private init() {
        super.init()
        if !FileManager.default.fileExists(atPath: CLBreakPointResumeManager.folderPath) {
            try? FileManager.default.createDirectory(atPath: CLBreakPointResumeManager.folderPath, withIntermediateDirectories: true)
        }
    }
}

extension CLBreakPointResumeManager {
    static func download(_ url: URL, progressBlock: ((_ url: URL, _ progress: CGFloat) -> Void)? = nil, completionBlock: ((Result<String, DownloadError>) -> Void)? = nil) {
        let key = url.absoluteString.md5()

        func notifyCallback(progress: CGFloat? = nil, result: Result<String, DownloadError>? = nil) {
            DispatchQueue.main.async {
                if let progress { shared.progressSet[key]?.forEach { $0(url, progress) } }
                if let result {
                    shared.completionsSet[key]?.forEach { $0(result) }
                    shared.progressSet[key] = nil
                    shared.completionsSet[key] = nil
                }
            }
        }

        if let progress = progressBlock { shared.progressSet[key] = [progress] }

        if let completion = completionBlock { shared.completionsSet[key] = [completion] }

        guard getOperation(key) == nil else { return }

        let fileAttribute = fileAttribute(url)

        guard !isDownloaded(url).0 else {
            notifyCallback(progress: 1, result: .success(fileAttribute.path))
            return
        }

        let operation = CLBreakPointResumeOperation(url: url, path: fileAttribute.path, currentBytes: fileAttribute.currentBytes)
        operation.progressBlock = { value in
            notifyCallback(progress: value)
        }
        operation.completionBlock = {
            if let error = operation.error {
                notifyCallback(result: .failure(error))
            } else {
                notifyCallback(result: .success(fileAttribute.path))
            }
            removeOperation(key)
        }
        shared.queue.addOperation(operation)
        setOperation(operation, for: key)
    }

    static func cancel(_ url: URL) {
        let key = url.absoluteString.md5()
        guard let operation = getOperation(key),
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
    static func getOperation(_ value: String) -> CLBreakPointResumeOperation? {
        shared.semaphore.wait()
        defer {
            shared.semaphore.signal()
        }
        return shared.operationDictionary[value]
    }

    static func setOperation(_ value: CLBreakPointResumeOperation, for key: String) {
        shared.semaphore.wait()
        defer {
            shared.semaphore.signal()
        }
        shared.operationDictionary[key] = value
    }

    static func removeOperation(_ value: String) {
        shared.semaphore.wait()
        defer {
            shared.semaphore.signal()
        }
        shared.operationDictionary.removeValue(forKey: value)
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
        (filePath(url), fileCurrentBytes(url), fileTotalBytes(url))
    }

    static func filePath(_ url: URL) -> String {
        folderPath + url.absoluteString.md5() + (url.pathExtension.isEmpty ? "" : ".\(url.pathExtension)")
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
        var totalBytes: Int64 = 0
        if let sizeData = try? URL(fileURLWithPath: filePath(url)).extendedAttribute(forName: "totalBytes") {
            (sizeData as NSData).getBytes(&totalBytes, length: sizeData.count)
        }
        return totalBytes
    }
}
