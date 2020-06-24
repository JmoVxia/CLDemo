//
//  CLNamespace.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/6/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

/// 类型协议
public protocol CLTypeWrapperProtocol {
    associatedtype CLWrappedType
    var CLWrappedValue: CLWrappedType { get }
    init(value: CLWrappedType)
}
public struct CLNamespaceWrapper<T>: CLTypeWrapperProtocol {
    public let CLWrappedValue: T
    public init(value: T) {
        self.CLWrappedValue = value
    }
}
/// 命名空间协议
public protocol CLNamespaceWrappable {
    associatedtype CLWrappedType
    var cl: CLWrappedType { get }
    static var cl: CLWrappedType.Type { get }
}
extension CLNamespaceWrappable {
    public var cl: CLNamespaceWrapper<Self> {
        return CLNamespaceWrapper(value: self)
    }
    public static var cl: CLNamespaceWrapper<Self>.Type {
        return CLNamespaceWrapper.self
    }
}

