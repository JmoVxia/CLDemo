//
//  CLPath.swift
//  CKD
//
//  Created by Chen JmoVxia on 2023/1/13.
//  Copyright © 2023 JmoVxia. All rights reserved.
//

import Foundation

enum CLPath {
    enum Folder {
        /// 沙盒 Documents 路径
        static let documents = NSHomeDirectory() + "/Documents"
        /// 沙盒 tmp 路径
        static let tmp = NSHomeDirectory() + "/tmp"
        /// IM文件夹路径
        static let chatFile = documents
    }
}
