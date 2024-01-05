//
//  CLBreakPointResumeOperation.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/6/10.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLBreakPointResumeOperation: Operation {
    var progressHandler: ((CGFloat) -> Void)?

    private(set) var error: CLBreakPointResumeManager.DownloadError?

    private var url: URL!

    private var localPath: String!

    private var urlSession: URLSession!

    private var dataTask: URLSessionDataTask!

    private var currentBytes: Int64 = 0

    private var outputStream: OutputStream?

    private var isTaskFinished: Bool = true {
        willSet {
            if isTaskFinished != newValue {
                willChangeValue(forKey: "isFinished")
            }
        }
        didSet {
            if isTaskFinished != oldValue {
                didChangeValue(forKey: "isFinished")
            }
        }
    }

    private var isTaskExecuting: Bool = false {
        willSet {
            if isTaskExecuting != newValue {
                willChangeValue(forKey: "isExecuting")
            }
        }
        didSet {
            if isTaskExecuting != oldValue {
                didChangeValue(forKey: "isExecuting")
            }
        }
    }

    override var isFinished: Bool {
        isTaskFinished
    }

    override var isExecuting: Bool {
        isTaskExecuting
    }

    override var isAsynchronous: Bool {
        true
    }

    init(url: URL, localPath: String, currentBytes: Int64) {
        super.init()
        self.url = url
        self.localPath = localPath
        self.currentBytes = currentBytes

        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        if currentBytes > 0 {
            let requestRange = String(format: "bytes=%llu-", currentBytes)
            request.addValue(requestRange, forHTTPHeaderField: "Range")
        }
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        dataTask = urlSession.dataTask(with: request)
    }

    deinit {
        print("CLBreakPointResumeOperation deinit")
    }
}

extension CLBreakPointResumeOperation {
    override func start() {
        autoreleasepool {
            if isCancelled {
                isTaskFinished = true
                isTaskExecuting = false
            } else {
                isTaskFinished = false
                isTaskExecuting = true
                startDataTask()
            }
        }
    }

    override func cancel() {
        if isExecuting {
            dataTask.cancel()
        }
        super.cancel()
    }
}

private extension CLBreakPointResumeOperation {
    func startDataTask() {
        dataTask.resume()
    }

    func complete(with error: CLBreakPointResumeManager.DownloadError? = nil) {
        self.error = error
        outputStream?.close()
        outputStream = nil
        isTaskFinished = true
        isTaskExecuting = false
    }
}

extension CLBreakPointResumeOperation: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard !isCancelled else { return }
        guard let httpResponse = response as? HTTPURLResponse else {
            return complete(with: .notHTTPURLResponse)
        }
        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 206 else {
            return complete(with: .statusCode(httpResponse.statusCode))
        }
        if httpResponse.statusCode == 200, FileManager.default.fileExists(atPath: localPath) {
            do {
                try FileManager.default.removeItem(atPath: localPath)
                currentBytes = 0
            } catch {
                return complete(with: .throws(error))
            }
        }
        outputStream = OutputStream(url: URL(fileURLWithPath: localPath), append: true)
        outputStream?.open()
        if currentBytes == 0 {
            do {
                try URL(fileURLWithPath: localPath).setEncodableExtendedAttribute(value: httpResponse.expectedContentLength, forName: "totalBytes")
            } catch {
                complete(with: .throws(error))
                return
            }
        }
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        session.invalidateAndCancel()
        guard let httpResponse = task.response as? HTTPURLResponse else {
            complete(with: .notHTTPURLResponse)
            return
        }
        if let error {
            complete(with: .download(error))
        } else if httpResponse.statusCode == 200 || httpResponse.statusCode == 206 {
            complete()
        } else {
            complete(with: .statusCode(httpResponse.statusCode))
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard !isCancelled else { return }
        let receivedBytes = dataTask.countOfBytesReceived + currentBytes
        let totalBytes = dataTask.countOfBytesExpectedToReceive + currentBytes
        let currentProgress = min(max(0, CGFloat(receivedBytes) / CGFloat(totalBytes)), 1)
        DispatchQueue.main.async {
            self.progressHandler?(currentProgress)
        }
        outputStream?.write(Array(data), maxLength: data.count)
    }
}
