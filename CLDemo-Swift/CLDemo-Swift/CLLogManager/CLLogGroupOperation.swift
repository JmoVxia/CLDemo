//
//  CLLogGroupOperation.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2025/7/30.
//

import Foundation

class CLLogGroupOperation: CLBaseAsyncOperation, @unchecked Sendable {
    private let filePaths: [String]

    private lazy var uploadQueue: OperationQueue = {
        let queue = OperationQueue()
        return queue
    }()

    init(filePaths: [String], maxConcurrentUploads: Int = 1) {
        self.filePaths = filePaths
        super.init()
        uploadQueue.maxConcurrentOperationCount = max(1, maxConcurrentUploads)
    }

    deinit {
        print("CLLogGroupOperation deinit")
    }
}

extension CLLogGroupOperation {
    override func startTask(completion: @escaping () -> Void) {
        guard !isCancelled else { completion(); return }
        guard !filePaths.isEmpty else { completion(); return }

        let completionOperation = BlockOperation { completion() }

        for path in filePaths {
            if isCancelled { break }
            let uploadOperation = CLLogUploadOperation(filePath: path)
            completionOperation.addDependency(uploadOperation)
            uploadQueue.addOperation(uploadOperation)
        }

        uploadQueue.addOperation(completionOperation)
    }
}
