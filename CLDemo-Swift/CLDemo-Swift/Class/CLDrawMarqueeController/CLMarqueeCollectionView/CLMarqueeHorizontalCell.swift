//
//  CLDrawMarqueeCell.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/11/10.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLMarqueeHorizontalCell: UICollectionViewCell {
    lazy var label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
