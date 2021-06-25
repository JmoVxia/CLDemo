//
//  CLBreakPointResumeOperation.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/6/10.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLBreakPointResumeOperation: Operation {
    var progressBlock: ((CGFloat) -> ())?
    private (set) var error: CLBreakPointResumeManager.DownloadError?
    private var url: URL!
    private var path: String!
    private var currentBytes: Int64 = 0
    private var session: URLSession!
    private var task: URLSessionDataTask!
    private var outputStream: OutputStream?
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
    override var isFinished: Bool {
        return taskFinished
    }
    override var isExecuting: Bool {
        return taskExecuting
    }
    override var isAsynchronous: Bool {
        return true
    }
    init(url: URL, path: String, currentBytes: Int64) {
        super.init()
        self.url = url
        self.path = path
        self.currentBytes = currentBytes
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        if currentBytes > 0 {
            let requestRange = String(format: "bytes=%llu-", currentBytes)
            request.addValue(requestRange, forHTTPHeaderField: "Range")
        }
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        task = session.dataTask(with: request)
    }
    deinit {
        print("CLBreakPointResumeOperation deinit")
    }
}
extension CLBreakPointResumeOperation {
    override func start() {
        autoreleasepool {
            if isCancelled {
                taskFinished = true
                taskExecuting = false
            }else {
                taskFinished = false
                taskExecuting = true
                startTask()
            }
        }
    }
    override func cancel() {
        if (isExecuting) {
            task.cancel()
        }
        super.cancel()
    }
}
private extension CLBreakPointResumeOperation {
    func startTask() {
        task.resume()
    }
    func complete(_ error: CLBreakPointResumeManager.DownloadError? = nil) {
        self.error = error
        outputStream?.close()
        outputStream = nil
        taskFinished = true
        taskExecuting = false
    }
}
extension CLBreakPointResumeOperation: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if !isCancelled {
            guard let response = dataTask.response as? HTTPURLResponse else {
                complete(.notHTTPURLResponse)
                return
            }
            guard response.statusCode == 200 || response.statusCode == 206 else {
                complete(.statusCode(response.statusCode))
                return
            }
            if response.statusCode == 200,
               FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    currentBytes = 0
                } catch  {
                    complete(.throws(error))
                    return
                }
            }
            outputStream = OutputStream(url: URL(fileURLWithPath: path), append: true)
            outputStream?.open()
            if currentBytes == 0 {
                var totalBytes = response.expectedContentLength
                let data = Data(bytes: &totalBytes, count: MemoryLayout.size(ofValue: totalBytes))
                do {
                    try URL(fileURLWithPath: path).setExtendedAttribute(data: data, forName: "totalBytes")
                } catch {
                    complete(.throws(error))
                    return
                }
            }
            completionHandler(.allow)
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        session.invalidateAndCancel()
        guard let response = task.response as? HTTPURLResponse else {
            complete(.notHTTPURLResponse)
            return
        }
        if let error = error {
            complete(.download(error))
        }else if (response.statusCode == 200 || response.statusCode == 206) {
            complete()
        }else {
            complete(.statusCode(response.statusCode))
        }
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if !isCancelled {
            let receiveBytes = dataTask.countOfBytesReceived + currentBytes
            let allBytes = dataTask.countOfBytesExpectedToReceive + currentBytes
            let currentProgress = min(max(0, CGFloat(receiveBytes) / CGFloat(allBytes)), 1)
            DispatchQueue.main.async {
                self.progressBlock?(currentProgress)
            }
            outputStream?.write(Array(data), maxLength: data.count)
        }
    }
}
