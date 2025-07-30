//
//  CLLogUploadOperation.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2025/7/30.
//

import UIKit

import Foundation

class CLLogUploadOperation: Operation, @unchecked Sendable {
    var completionCallback: ((Swift.Result<Void, Error>) -> Void)?

    private let filePaths: [String]

    private let maxConcurrentUploads: Int

    private var taskFinished: Bool = true {
        willSet {
            if taskFinished != newValue {
                willChangeValue(forKey: "isFinished")
            }
        }
        didSet {
            if taskFinished != oldValue {
                didChangeValue(forKey: "isFinished")
            }
        }
    }

    private var taskExecuting: Bool = false {
        willSet {
            if taskExecuting != newValue {
                willChangeValue(forKey: "isExecuting")
            }
        }
        didSet {
            if taskExecuting != oldValue {
                didChangeValue(forKey: "isExecuting")
            }
        }
    }

    override var isFinished: Bool { taskFinished }
    
    override var isExecuting: Bool { taskExecuting }
    
    override var isAsynchronous: Bool { true }


    init(filePaths: [String], maxConcurrentUploads: Int = 1) {
        self.filePaths = filePaths
        self.maxConcurrentUploads = max(1, maxConcurrentUploads)
        super.init()
    }

    deinit {
        print("CLLogUploadOperation deinit")
    }
}

extension CLLogUploadOperation {
    override func start() {
        autoreleasepool {
            if isCancelled {
                taskFinished = true
                taskExecuting = false
            } else {
                taskFinished = false
                taskExecuting = true
                startUploadTask { [weak self] in
                    self?.taskExecuting = false
                    self?.taskFinished = true
                }
            }
        }
    }

    override func cancel() {
        super.cancel()
        if isExecuting {
            taskExecuting = false
            taskFinished = true
        }
    }
}

extension CLLogUploadOperation {
    private func startUploadTask(complete: @escaping () -> Void) {
        let group = DispatchGroup()
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = maxConcurrentUploads

        var uploadError: Error?

        for path in filePaths {
            if isCancelled { break }

            group.enter()
            queue.addOperation {
                defer { group.leave() }

                // 模拟上传
                print("上传开始：\(path)")
                Thread.sleep(forTimeInterval: 1.0)

                // TODO: 替换为你实际的 OSS 上传代码
                let success = true // 模拟成功

                if success {
                    do {
                        try FileManager.default.removeItem(atPath: path)
                        print("上传并删除成功：\(path)")
                    } catch {
                        print("删除失败：\(path), error: \(error)")
                    }
                } else {
                    print("上传失败：\(path)")
                    uploadError = NSError(domain: "upload", code: 1, userInfo: [NSLocalizedDescriptionKey: "上传失败"])
                }
            }
        }

        group.notify(queue: .main) {
            if let error = uploadError {
                self.completionCallback?(.failure(error))
            } else {
                self.completionCallback?(.success(()))
            }
            complete()
        }
    }
}
