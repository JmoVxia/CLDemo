//
//  URL+Extension.swift
//  ResumeFromBreakPoint
//
//  Created by Chen JmoVxia on 2021/6/10.
//  Copyright © 2021 whde. All rights reserved.
//

import Foundation
import SwiftyJSON

extension URL {
    /// Read Decodable extension attribute.
    func readDecodableExtendedAttribute<T: Decodable>(forName name: String, type: T.Type) throws -> T {
        let data = try readExtendedAttribute(forName: name)
        return try JSONDecoder().decode(T.self, from: data)
    }

    /// Set Encodable extension attribute.
    func setEncodableExtendedAttribute(value: some Encodable, forName name: String) throws {
        let data = try JSONEncoder().encode(value)
        try setExtendedAttribute(data: data, forName: name)
    }

    /// Get extended attribute.
    func readExtendedAttribute(forName name: String) throws -> Data {
        let data = try withUnsafeFileSystemRepresentation { fileSystemPath -> Data in
            // Determine attribute size:
            let length = getxattr(fileSystemPath, name, nil, 0, 0, 0)
            guard length >= 0 else { throw URL.posixError(errno) }
            // Create buffer with required size:
            var data = Data(count: length)
            // Retrieve attribute:
            let result = data.withUnsafeMutableBytes { [count = data.count] in
                getxattr(fileSystemPath, name, $0.baseAddress, count, 0, 0)
            }
            guard result >= 0 else { throw URL.posixError(errno) }
            return data
        }
        return data
    }

    /// Set extended attribute.
    func setExtendedAttribute(data: Data, forName name: String) throws {
        try withUnsafeFileSystemRepresentation { fileSystemPath in
            let result = data.withUnsafeBytes {
                setxattr(fileSystemPath, name, $0.baseAddress, data.count, 0, 0)
            }
            guard result >= 0 else { throw URL.posixError(errno) }
        }
    }

    /// Remove extended attribute.
    func removeExtendedAttribute(forName name: String) throws {
        try withUnsafeFileSystemRepresentation { fileSystemPath in
            let result = removexattr(fileSystemPath, name, 0)
            guard result >= 0 else { throw URL.posixError(errno) }
        }
    }

    /// Get list of all extended attributes.
    func listExtendedAttributes() throws -> [String] {
        let list = try withUnsafeFileSystemRepresentation { fileSystemPath -> [String] in
            let length = listxattr(fileSystemPath, nil, 0, 0)
            guard length >= 0 else { throw URL.posixError(errno) }
            // Create buffer with required size:
            var namebuf = [CChar](repeating: 0, count: length)
            // Retrieve attribute list:
            let result = listxattr(fileSystemPath, &namebuf, namebuf.count, 0)
            guard result >= 0 else { throw URL.posixError(errno) }
            // Extract attribute names:
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

    /// Helper function to create an NSError from a Unix errno.
    private static func posixError(_ err: Int32) -> NSError {
        NSError(domain: NSPOSIXErrorDomain, code: Int(err), userInfo: [NSLocalizedDescriptionKey: String(cString: strerror(err))])
    }
}

public extension URL {
    var parameters: JSON {
        let array = absoluteString.removingPercentEncoding?.components(separatedBy: "?")
        guard array?.count == 2 else { return JSON() }
        guard let paramsString = array?.last else { return JSON() }
        guard !paramsString.isEmpty else { return JSON() }
        var params: [String: String] = [:]
        for param in paramsString.components(separatedBy: "&") {
            let elements = param.components(separatedBy: "=")
            guard elements.count == 2 else { continue }
            params[elements[0]] = elements[1]
        }
        return JSON(params)
    }
}
