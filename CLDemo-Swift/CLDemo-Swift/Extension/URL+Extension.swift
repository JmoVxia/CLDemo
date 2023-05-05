//
//  URL+Extension.swift
//  ResumeFromBreakPoint
//
//  Created by Chen JmoVxia on 2021/6/10.
//  Copyright © 2021 whde. All rights reserved.
//

import Foundation

extension URL {
    /// 读取JSON扩展属性。
    func readJSONAttribute<T: Decodable>(forName name: String, type: T.Type) throws -> T {
        let data = try extendedAttribute(forName: name)
        return try JSONDecoder().decode(T.self, from: data)
    }

    /// 设置JSON扩展属性。
    func setJSONAttribute(value: some Encodable, forName name: String) throws {
        let data = try JSONEncoder().encode(value)
        try setExtendedAttribute(data: data, forName: name)
    }

    /// 获取扩展属性。
    func extendedAttribute(forName name: String) throws -> Data {
        let data = try withUnsafeFileSystemRepresentation { fileSystemPath -> Data in
            // 确定属性的大小：
            let length = getxattr(fileSystemPath, name, nil, 0, 0, 0)
            guard length >= 0 else { throw URL.posixError(errno) }
            // 创建具有所需大小的缓冲区：
            var data = Data(count: length)
            // 检索属性：
            let result = data.withUnsafeMutableBytes { [count = data.count] in
                getxattr(fileSystemPath, name, $0.baseAddress, count, 0, 0)
            }
            guard result >= 0 else { throw URL.posixError(errno) }
            return data
        }
        return data
    }

    /// 设置扩展属性。
    func setExtendedAttribute(data: Data, forName name: String) throws {
        try withUnsafeFileSystemRepresentation { fileSystemPath in
            let result = data.withUnsafeBytes {
                setxattr(fileSystemPath, name, $0.baseAddress, data.count, 0, 0)
            }
            guard result >= 0 else { throw URL.posixError(errno) }
        }
    }

    /// 移除扩展属性。
    func removeExtendedAttribute(forName name: String) throws {
        try withUnsafeFileSystemRepresentation { fileSystemPath in
            let result = removexattr(fileSystemPath, name, 0)
            guard result >= 0 else { throw URL.posixError(errno) }
        }
    }

    /// 获取所有扩展属性的列表。
    func listExtendedAttributes() throws -> [String] {
        let list = try withUnsafeFileSystemRepresentation { fileSystemPath -> [String] in
            let length = listxattr(fileSystemPath, nil, 0, 0)
            guard length >= 0 else { throw URL.posixError(errno) }
            // 创建具有所需大小的缓冲区：
            var namebuf = [CChar](repeating: 0, count: length)
            // 检索属性列表：
            let result = listxattr(fileSystemPath, &namebuf, namebuf.count, 0)
            guard result >= 0 else { throw URL.posixError(errno) }
            // 提取属性名称：
            let list = namebuf.split(separator: 0).compactMap {
                $0.withUnsafeBufferPointer {
                    $0.withMemoryRebound(to: UInt8.self) {
                        String(bytes: $0, encoding: .utf8)
                    }
                }
            }
            return list
        }
        return list
    }

    /// 从Unix errno创建NSError的辅助函数。
    private static func posixError(_ err: Int32) -> NSError {
        NSError(domain: NSPOSIXErrorDomain, code: Int(err), userInfo: [NSLocalizedDescriptionKey: String(cString: strerror(err))])
    }
}
