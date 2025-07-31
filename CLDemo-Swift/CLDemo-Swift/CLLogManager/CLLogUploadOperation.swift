//
//  CLLogUploadOperation.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2025/7/30.
//

import Foundation

class CLLogUploadOperation: CLBaseAsyncOperation, @unchecked Sendable {
    private let filePath: String

    init(filePath: String) {
        self.filePath = filePath
        super.init()
    }

    deinit {
        print("CLLogUploadOperation deinit")
    }
}

extension CLLogUploadOperation {
    override func startTask(completion: @escaping () -> Void) {
        guard !isCancelled else { completion(); return }
        // TODO: 替换为你实际的 OSS 上传代码
        print("上传开始：\(filePath)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let success = true
//            if success {
//                do {
//                    try FileManager.default.removeItem(atPath: self.filePath)
//                    print("上传并删除成功：\(self.filePath)")
//                } catch {
//                    print("删除失败：\(self.filePath), error: \(error)")
//                }
//            } else {
            ////                print("上传失败：\(self.filePath)")
//            }
            print("上传成功：\(self.filePath)")
            completion()
        }
    }
}
