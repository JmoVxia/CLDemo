//
//  StringError.swift
//  CKD
//
//  Created by Chen JmoVxia on 2021/9/27.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

/// 字符串错误
struct StringError: Error {
    /// 描述
    let description: String
}

extension StringError: LocalizedError {
    var errorDescription: String? {
        description
    }
}
