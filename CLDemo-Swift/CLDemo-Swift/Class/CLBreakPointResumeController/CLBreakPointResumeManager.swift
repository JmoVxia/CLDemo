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
        /// Downloading in progress
        case downloading
        /// Not an HTTPURLResponse type
        case notHTTPURLResponse
        /// Error thrown
        case `throws`(Error)
        /// Status code error
        case statusCode(Int)
        /// Download error
        case download(Error)
    }
}

class CLBreakPointResumeManager: NSObject {
    static let shared: CLBreakPointResumeManager = .init()

    private let folderPath: String = NSHomeDirectory() + "/Documents/CLBreakPointResume/"

    private var operationDictionary = [String: CLBreakPointResumeOperation]()

    private var progressCallbacks = CLSafeArrayDictionary<String, (CGFloat) -> Void>()

    private var completionCallbacks = CLSafeArrayDictionary<String, (Result<String, DownloadError>) -> Void>()

    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }()

    private lazy var semaphore: DispatchSemaphore = {
        let sema = DispatchSemaphore(value: 0)
        sema.signal()
        return sema
    }()

    override private init() {
        super.init()
        guard !FileManager.default.fileExists(atPath: folderPath) else { return }
        try? FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true)
    }
}

extension CLBreakPointResumeManager {
    static func download(_ url: URL, progressBlock: ((CGFloat) -> Void)? = nil, completionBlock: ((Result<String, DownloadError>) -> Void)? = nil) {
        let key = url.absoluteString.md5()

        func notifyCallback(progress: CGFloat? = nil, result: Result<String, DownloadError>? = nil) {
            DispatchQueue.main.async {
                if let progress { shared.progressCallbacks[key]?.forEach { $0(progress) } }
                if let result {
                    shared.completionCallbacks[key]?.forEach { $0(result) }
                    shared.progressCallbacks[key] = nil
                    shared.completionCallbacks[key] = nil
                }
            }
        }

        if let progress = progressBlock { shared.progressCallbacks[key] = [progress] }

        if let completion = completionBlock { shared.completionCallbacks[key] = [completion] }

        guard getOperation(key) == nil else { return }

        let fileAttribute = fileAttribute(url)

        guard isDownloaded(url) != nil else {
            notifyCallback(progress: 1, result: .success(fileAttribute.path))
            return
        }

        let operation = CLBreakPointResumeOperation(url: url, localPath: fileAttribute.path, currentBytes: fileAttribute.currentBytes)
        operation.progressHandler = { value in
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
        shared.operationQueue.addOperation(operation)
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
        try FileManager.default.removeItem(atPath: shared.folderPath)
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
    static func isDownloaded(_ url: URL) -> String? {
        let fileAttribute = fileAttribute(url)
        guard fileAttribute.currentBytes != 0, fileAttribute.currentBytes == fileAttribute.totalBytes else { return nil }
        return fileAttribute.path
    }
}

extension CLBreakPointResumeManager {
    static func fileAttribute(_ url: URL) -> (path: String, currentBytes: Int64, totalBytes: Int64) {
        (filePath(url), fileCurrentBytes(url), fileTotalBytes(url))
    }

    static func filePath(_ url: URL) -> String {
        shared.folderPath + url.absoluteString.md5() + (url.pathExtension.isEmpty ? "" : ".\(url.pathExtension)")
    }

    static func fileCurrentBytes(_ url: URL) -> Int64 {
        (try? FileManager.default.attributesOfItem(atPath: filePath(url)))?[.size] as? Int64 ?? 0
    }

    static func fileTotalBytes(_ url: URL) -> Int64 {
        let totalBytes = try? URL(fileURLWithPath: filePath(url)).readDecodableExtendedAttribute(forName: "totalBytes", type: Int64.self)
        return totalBytes ?? .zero
    }
}
