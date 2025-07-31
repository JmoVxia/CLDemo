//
//  CLLogManager.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2025/7/28.
//

import CocoaLumberjack
import UIKit

// MARK: - JmoVxia---枚举

struct CLLogLevel: OptionSet {
    let rawValue: Int

    static let error = CLLogLevel(rawValue: 1 << 0)
    static let warning = CLLogLevel(rawValue: 1 << 1)
    static let message = CLLogLevel(rawValue: 1 << 2)
    static let debug = CLLogLevel(rawValue: 1 << 3)
    static let im = CLLogLevel(rawValue: 1 << 4)

    static let all: CLLogLevel = .init(allLevels.map(\.level))

    private static let allLevels: [(level: CLLogLevel, name: String)] = [
        (.error, "错误"),
        (.warning, "警告"),
        (.message, "信息"),
        (.debug, "调试"),
        (.im, "聊天"),
    ]

    func chineseDescription() -> String {
        let descriptions = CLLogLevel.allLevels
            .filter { contains($0.level) }
            .map(\.name)
            .joined(separator: "-")
        return descriptions
    }
}

// MARK: - JmoVxia---自定义格式

private class CLLogFormatter: NSObject, DDLogFormatter {
    override init() {
        super.init()
    }

    func format(message logMessage: DDLogMessage) -> String? {
//        let custom = logMessage.representedObject as? (CLLogLevel, String) ?? (.message, "")
//        let timestamp = logMessage.timestamp.formattedString()
//        let text = """
//        ------------------------------------------
//        生命周期: \(custom.1)
//        日志类型: \(custom.0.chineseDescription())
//        记录时间: \(timestamp)
//        执行上下文: 队列—\(logMessage.queueLabel) | 线程ID—\(logMessage.threadID) | 线程名—\(String(describing: logMessage.threadName))
//        调用位置: [\(logMessage.fileName):\(logMessage.line) \(logMessage.function ?? "")]
//
//        \(logMessage.message)
//
//        """

        let customInfo = logMessage.representedObject as? (CLLogLevel, String) ?? (.message, "")
        let lifecycleId = customInfo.1
        let logLevel = customInfo.0

        let displayThreadName = if logMessage.queueLabel == "com.apple.main-thread" {
            "主线程"
        } else if let threadName = logMessage.threadName, !threadName.isEmpty {
            "自定义线程-\(threadName)"
        } else {
            "子线程"
        }
        let logDict: [String: Any] = [
            "timestamp": logMessage.timestamp.formattedString(),
            "lifecycleId": lifecycleId,
            "logTypes": logLevel.chineseDescription(),
            "message": logMessage.message,
            "fileName": logMessage.fileName,
            "line": logMessage.line,
            "function": logMessage.function ?? "",
            "queueLabel": logMessage.queueLabel,
            "threadID": logMessage.threadID,
            "threadName": displayThreadName,
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: logDict, options: []) else {
            return nil
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }

        return jsonString + "\n"
    }
}

// MARK: - JmoVxia---文件管理类

private class CLLogFileManager: DDLogFileManagerDefault {
    var didArchiveLogFile: ((_ path: String, _ wasRolled: Bool) -> Void)?

    override var newLogFileName: String {
        "\(Date().formattedString(format: "yyyy-MM-dd_HH-mm-ss-SSS"))+\(CLLogManager.shared.lifecycleID).log"
    }

    override func isLogFile(withName fileName: String) -> Bool {
        fileName.hasSuffix(".log")
    }

    override func didArchiveLogFile(atPath logFilePath: String, wasRolled: Bool) {
        didArchiveLogFile?(logFilePath, wasRolled)
    }
}

// MARK: - JmoVxia---日志管理类

class CLLogManager: NSObject {
    static let shared = CLLogManager()

    @CLThreadSafe private(set) var lifecycleID = generateLifecycleID()

    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    private var hasEnteredBackground = false

    private lazy var uploadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    private lazy var logFileManager: CLLogFileManager = {
        let manager = CLLogFileManager()
        manager.didArchiveLogFile = { path, _ in
            CLLogManager.upload(path)
        }
        return manager
    }()

    private lazy var fileLogger: DDFileLogger = {
        let logger = DDFileLogger(logFileManager: logFileManager)
        logger.logFormatter = CLLogFormatter()
        logger.rollingFrequency = 0
        logger.logFileManager.maximumNumberOfLogFiles = 100
        logger.maximumFileSize = 50 * 1024
        logger.doNotReuseLogFiles = true
        return logger
    }()

    override private init() {
        super.init()
        CLLogManager.setupObservers()
        DDLog.add(fileLogger)
    }
}

// MARK: - JmoVxia---公共方法

extension CLLogManager {
    static func start() {
        upload()
    }

    static func CLLog(_ message: String, level: CLLogLevel = .message, file: String = #file, function: String = #function, line: UInt = #line) {
        let logMessage = DDLogMessage(format: message,
                                      formatted: message,
                                      level: .verbose,
                                      flag: .verbose,
                                      context: 0,
                                      file: file,
                                      function: function,
                                      line: line,
                                      tag: (level, shared.lifecycleID),
                                      options: [],
                                      timestamp: Date())
        DDLog.log(asynchronous: true, message: logMessage)
    }
}

// MARK: - JmoVxia---OC桥接方法

@objc extension CLLogManager {
    static func logForObjectiveC(_ message: String, level: Int, file: String = #file, function: String = #function, line: UInt = #line) {
        CLLog(message, level: .init(rawValue: level), file: file, function: function, line: line)
    }
}

// MARK: - JmoVxia---监听

private extension CLLogManager {
    static func setupObservers() {
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            CLLogManager.appWillEnterForeground()
        }

        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
            CLLogManager.didEnterBackgroundNotification()
        }
    }

    static func appWillEnterForeground() {
        if shared.hasEnteredBackground {
            shared.hasEnteredBackground = false
            shared.lifecycleID = generateLifecycleID()
        }
        upload()
    }

    static func didEnterBackgroundNotification() {
        shared.hasEnteredBackground = true
        beginBackgroundTask {
            shared.fileLogger.rollLogFile(withCompletion: nil)
        }
    }
}

// MARK: - JmoVxia---生命周期生成

private extension CLLogManager {
    static func generateLifecycleID() -> String {
        "\(Date().nanosecondStampString)_\(UUID().uuidString)".md5ForUpper32Bate
    }
}

// MARK: - JmoVxia---上传

private extension CLLogManager {
    static func upload(_ path: String? = nil) {
        let paths = path != nil ? [path!] : shared.logFileManager.sortedLogFileInfos.filter(\.isArchived).map(\.filePath)
        guard !paths.isEmpty else { return }
        let operation = CLLogGroupOperation(filePaths: paths, maxConcurrentUploads: 5)
        operation.completionBlock = {
            endBackgroundTask()
        }
        shared.uploadQueue.addOperation(operation)
    }
}

// MARK: - JmoVxia---后台任务

private extension CLLogManager {
    static func beginBackgroundTask(handler: () -> Void) {
        shared.backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "UploadLog") {
            self.endBackgroundTask()
        }
        guard shared.backgroundTask != .invalid else { return }
        handler()
    }

    static func endBackgroundTask() {
        guard shared.backgroundTask != .invalid else { return }
        UIApplication.shared.endBackgroundTask(shared.backgroundTask)
        shared.backgroundTask = .invalid
    }
}
