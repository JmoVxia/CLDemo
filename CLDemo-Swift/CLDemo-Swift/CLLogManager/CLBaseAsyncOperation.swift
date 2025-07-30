//
//  CLBaseAsyncOperation.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2025/7/30.
//

import Foundation

private extension CLBaseAsyncOperation {
    enum OperationState: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"

        var isReady: Bool { self == .ready }
        var isExecuting: Bool { self == .executing }
        var isFinished: Bool { self == .finished }
    }
}

// MARK: - 异步 Operation 基类

class CLBaseAsyncOperation: Operation, @unchecked Sendable {
    private var state: OperationState = .ready {
        willSet {
            guard state != newValue else { return }
            willChangeValue(forKey: state.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        didSet {
            guard state != oldValue else { return }
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }

    override var isReady: Bool { super.isReady && state.isReady }
    override var isExecuting: Bool { state.isExecuting }
    override var isFinished: Bool { state.isFinished }
    override var isAsynchronous: Bool { true }
}

extension CLBaseAsyncOperation {
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing
            startTask { [weak self] in
                self?.state = .finished
            }
        }
    }

    override func cancel() {
        super.cancel()
        guard isExecuting else { return }
        state = .finished
    }
}

extension CLBaseAsyncOperation {
    @objc func startTask(completion: @escaping () -> Void) { completion() }
}
