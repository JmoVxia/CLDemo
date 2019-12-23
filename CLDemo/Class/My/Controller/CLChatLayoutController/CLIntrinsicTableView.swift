//
//  CLIntrinsicTableView.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/26.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLIntrinsicTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            let height = max(frame.height - contentSize.height, 0)
            let oldHeight = contentInset.top
            if height != oldHeight {
                contentInset = UIEdgeInsets(top: max(height, 0), left: 0, bottom: 0, right: 0)
            }
        }
    }
}
