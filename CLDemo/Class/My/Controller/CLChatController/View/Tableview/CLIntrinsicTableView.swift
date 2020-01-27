//
//  CLIntrinsicTableView.swift
//  CLDemo
//
//  Created by Emma on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLIntrinsicTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            let height = max(frame.height - contentSize.height, 0)
            let oldHeight = contentInset.top
            if height != oldHeight {
                showsVerticalScrollIndicator = height == 0.0
                contentInset = UIEdgeInsets(top: max(height, 0), left: 0, bottom: 0, right: 0)
            }
        }
    }
}
