//
//  CLInfiniteCollectionViewCell.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/11/4.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLInfiniteViewCell: UICollectionViewCell {
    lazy var label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.backgroundColor = UIColor.red.withAlphaComponent(0.35)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
