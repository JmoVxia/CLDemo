//
//  CLNamespace.swift
//  CocoaSyncSocket
//
//  Created by JmoVxia on 2020/7/6.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

/// 类型协议
public protocol CLTypeWrapperProtocol {
    associatedtype CLWrappedType
    var value: CLWrappedType { get }
    init(value: CLWrappedType)
}
public struct CLNamespaceWrapper<T>: CLTypeWrapperProtocol {
    public let value: T
    public init(value: T) {
        self.value = value
    }
}
/// 命名空间协议
public protocol CLNamespaceWrappable {
    associatedtype CLWrappedType
    var chat: CLWrappedType { get }
    static var chat: CLWrappedType.Type { get }
}
extension CLNamespaceWrappable {
    public var chat: CLNamespaceWrapper<Self> {
        return CLNamespaceWrapper(value: self)
    }
    public static var chat: CLNamespaceWrapper<Self>.Type {
        return CLNamespaceWrapper.self
    }
}

