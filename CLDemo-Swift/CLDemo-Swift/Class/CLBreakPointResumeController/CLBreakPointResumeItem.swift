//
//  CLBreakPointResumeItem.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/6/10.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLBreakPointResumeItem: NSObject {
    let url: URL!
    var progress: CGFloat = 0 {
        didSet {
            progressChangeCallback?(progress)
        }
    }

    var downloadCallback: ((URL) -> Void)?

    var cancelCallback: ((URL) -> Void)?

    var deleteCallback: ((URL) -> Void)?

    var progressChangeCallback: ((CGFloat) -> Void)?

    init(url: URL) {
        self.url = url
        let fileAttribute = CLBreakPointResumeManager.fileAttribute(url)
        progress = fileAttribute.totalBytes <= 0 ? 0 : min(max(0, CGFloat(fileAttribute.currentBytes) / CGFloat(fileAttribute.totalBytes)), 1)
    }
}

extension CLBreakPointResumeItem: CLRowItemProtocol {
    func cellClass() -> UITableViewCell.Type {
        CLBreakPointResumeCell.self
    }

    func cellHeight() -> CGFloat {
        110
    }
}
