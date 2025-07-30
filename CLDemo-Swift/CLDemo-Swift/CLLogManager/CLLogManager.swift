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

    static let info = CLLogLevel(rawValue: 1 << 2)

    static let debug = CLLogLevel(rawValue: 1 << 3)

    static let im = CLLogLevel(rawValue: 1 << 4)

    static let all: CLLogLevel = .init(allLevels.map(\.level))

    private static let allLevels: [(level: CLLogLevel, name: String)] = [
        (.error, "错误"),
        (.warning, "警告"),
        (.info, "信息"),
        (.debug, "调试"),
        (.im, "聊天"),
    ]

    func chineseName() -> String {
        let descriptions = CLLogLevel.allLevels
            .filter { contains($0.level) }
            .map(\.name)
            .joined(separator: "-")
        return "[\(descriptions)]"
    }
}

// MARK: - JmoVxia---自定义格式

private class CLLogFormatter: NSObject, DDLogFormatter {
    override init() {
        super.init()
    }

    func format(message logMessage: DDLogMessage) -> String? {
        let customLevel = logMessage.representedObject as? CLLogLevel ?? .info
        let timestamp = logMessage.timestamp.formattedString(format: "yyyy-MM-dd HH:mm:ss:SSS")
        let fileName = URL(fileURLWithPath: logMessage.file).lastPathComponent
        let text = """
        ------------------------------------------
        \(customLevel.chineseName()) \(timestamp) [\(fileName):\(logMessage.line) \(logMessage.function ?? "")]

        \(logMessage.message)

        """
        return text
    }
}

// MARK: - JmoVxia---文件管理类

private class CLLogFileManager: DDLogFileManagerDefault {
    var didArchiveLogFileHandle: ((_ path: String, _ wasRolled: Bool) -> Void)?

    override var newLogFileName: String {
        "\(Date().formattedString())+\(CLLogManager.lifecycleID).log"
    }

    override func didArchiveLogFile(atPath logFilePath: String, wasRolled: Bool) {
        didArchiveLogFileHandle?(logFilePath, wasRolled)
    }
}

// MARK: - JmoVxia---日志管理类

class CLLogManager: NSObject {
    private static let shared = CLLogManager()

    @CLThreadSafe private(set) static var lifecycleID = generateLifecycleID()

    private static var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    private lazy var uploadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    private lazy var logFileManager: CLLogFileManager = {
        let manager = CLLogFileManager()
        manager.didArchiveLogFileHandle = { path, wasRolled in
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
        CLLogManager.addNotification()
        DDLog.add(fileLogger)
    }
}

// MARK: - JmoVxia---公共方法

extension CLLogManager {
    static func startLoggingService() {
        appWillEnterForeground()
    }

    static func CLLog(_ message: String, level: CLLogLevel = .info, file: String = #file, function: String = #function, line: UInt = #line) {
        let logMessage = DDLogMessage(format: message,
                                      formatted: message,
                                      level: .verbose,
                                      flag: .verbose,
                                      context: 0,
                                      file: file,
                                      function: function,
                                      line: line,
                                      tag: level,
                                      options: [],
                                      timestamp: Date())
        DDLog.log(asynchronous: true, message: logMessage)
    }
}

// MARK: - JmoVxia---OC桥接方法

@objc extension CLLogManager {
    static func CLLogForOC(_ message: String, level: Int, file: String = #file, function: String = #function, line: UInt = #line) {
        CLLog(message, level: .init(rawValue: level), file: file, function: function, line: line)
    }
}

// MARK: - JmoVxia---监听

private extension CLLogManager {
    static func addNotification() {
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            CLLogManager.appWillEnterForeground()
        }

        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
            CLLogManager.appWillResignActive()
        }
    }

    static func appWillEnterForeground() {
        CLLogManager.lifecycleID = generateLifecycleID()
        CLLog("APP 进入前台")
        upload()
    }

    static func appWillResignActive() {
        CLLog("APP 进入后台")
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
        let paths = path != nil ? [path!] : shared.logFileManager.sortedLogFileInfos.filter { $0.isArchived == true }.map(\.filePath)
        let operation = CLLogUploadOperation(filePaths: paths, maxConcurrentUploads: 0)
        operation.completionCallback = { result in
            endBackgroundTask()
        }
        shared.uploadQueue.addOperation(operation)
    }
}

// MARK: - JmoVxia---后台任务

private extension CLLogManager {
    static func beginBackgroundTask(_ start: () -> Void) {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "UploadLog") {
            self.endBackgroundTask()
        }
        guard backgroundTask != .invalid else { return }
        start()
    }

    static func endBackgroundTask() {
        guard backgroundTask != .invalid else { return }
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
}
