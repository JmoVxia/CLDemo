//
//  CLVernierCaliperView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLVernierCaliperConfigure {
    ///文字字体
    var textFont: UIFont = PingFangSCMedium(14)
    ///间隔值，每两条相隔多少值
    var gap: Int = 12
    ///长线条
    var long: CGFloat  = 30.0
    ///短线条
    var short: CGFloat = 15.0
    ///单位
    var unit: String = ""
    ///最小值
    var minValue: CGFloat = 0.0
    ///最大值
    var maxValue: CGFloat = 100.0
    ///最小单位
    var minimumUnit: CGFloat = 1
    ///单位间隔
    var unitInterval: Int = 10
}
class CLVernierCaliperView: UIView {
    private var configure: CLVernierCaliperConfigure = CLVernierCaliperConfigure()
    private var section: Int = 0
    private var limitDecimal: NSDecimalNumber = NSDecimalNumber(0)
    private var indexValue: String = "" {
        didSet {
            if indexValue != oldValue {
                indexValueCallback?(indexValue)
            }
        }
    }
    var indexValueCallback: ((String) -> ())?
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor    = UIColor.hex("#F7F7F7")
        collectionView.bounces            = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(CLVernierCaliperHeaderCell.self, forCellWithReuseIdentifier: "CLVernierCaliperHeaderCell")
        collectionView.register(CLVernierCaliperFooterCell.self, forCellWithReuseIdentifier: "CLVernierCaliperFooterCell")
        collectionView.register(CLVernierCaliperMiddleCell.self, forCellWithReuseIdentifier: "CLVernierCaliperMiddleCell")
        return collectionView
    }()
    private lazy var indexView: CLIndexView = {
        let view = CLIndexView()
        view.triangleColor = .themeColor
        view.backgroundColor = UIColor.clear
        view.lineHeight = configure.long
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor.white
        addSubview(collectionView)
        addSubview(indexView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(6)
            make.height.equalTo(self).offset(-6)
        }
        indexView.snp.makeConstraints { (make) in
            make.top.height.centerX.equalToSuperview()
            make.width.equalTo(12)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLVernierCaliperView {
    private func setRealValue(realValue: CGFloat, animated: Bool) {
        collectionView.setContentOffset(CGPoint.init(x: round(realValue) * CGFloat(configure.gap), y: 0), animated:  animated)
    }
}
extension CLVernierCaliperView {
    ///设置数值
    func setValue(value: CGFloat, animated: Bool){
        let x = Int(round((value - configure.minValue) / configure.minimumUnit)) * Int(configure.gap)
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint.init(x: x, y: 0), animated: animated)
        }
    }
}
extension CLVernierCaliperView {
    ///更新配置
    func updateConfigure(_ configureCallback: ((CLVernierCaliperConfigure) -> ())) {
        configureCallback(configure)
        section = Int((configure.maxValue - configure.minValue) / configure.minimumUnit) / configure.unitInterval
        collectionView.reloadData()
    }
    ///更新指标颜色
    func updateIndexColor(_ color: UIColor) {
        indexView.triangleColor = color
    }
}
extension CLVernierCaliperView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + self.section
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLVernierCaliperHeaderCell", for: indexPath)
            if let cell = cell as? CLVernierCaliperHeaderCell {
                cell.backgroundColor = .clear
                cell.minValue = configure.minValue
                cell.unit = configure.unit
                cell.long = configure.long
                cell.textFont = configure.textFont
                cell.limitDecimal = NSDecimalNumber(value: Double(configure.minimumUnit))
            }
            return cell
        }else if indexPath.item == section + 1 {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLVernierCaliperFooterCell", for: indexPath)
            if let cell = cell as? CLVernierCaliperFooterCell {
                cell.backgroundColor = .clear
                cell.maxValue = configure.maxValue
                cell.unit = configure.unit
                cell.long = configure.long
                cell.textFont = configure.textFont
                cell.limitDecimal = NSDecimalNumber(value: Double(configure.minimumUnit))
            }
            return cell
        }else{
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLVernierCaliperMiddleCell", for: indexPath)
            if let cell = cell as? CLVernierCaliperMiddleCell {
                cell.backgroundColor = .clear
                cell.minimumUnit = configure.minimumUnit
                cell.unit = configure.unit
                cell.unitInterval = configure.unitInterval;
                cell.minValue = configure.minimumUnit * CGFloat((indexPath.item - 1)) * CGFloat(configure.unitInterval) + configure.minValue
                cell.maxValue = configure.minimumUnit * CGFloat(indexPath.item) * CGFloat(configure.unitInterval)
                cell.textFont = configure.textFont
                cell.gap = configure.gap
                cell.long = configure.long
                cell.short = configure.short
                cell.limitDecimal = NSDecimalNumber(value: Double(configure.minimumUnit))
                cell.setNeedsDisplay()
            }
            return cell
        }
    }
}
extension CLVernierCaliperView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value: Int = Int(scrollView.contentOffset.x / CGFloat(configure.gap))
        var realValue: CGFloat = CGFloat(value) * configure.minimumUnit + configure.minValue
        realValue = min(max(realValue, configure.minValue), configure.maxValue)
        indexValue = NSDecimalNumber(value: Double(realValue)).stringFormatter(withExample: NSDecimalNumber(value: Double(configure.minimumUnit)))
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.setRealValue(realValue: (scrollView.contentOffset.x) / CGFloat(configure.gap),  animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.setRealValue(realValue: (scrollView.contentOffset.x) / CGFloat(configure.gap),  animated: true)
    }
}
extension CLVernierCaliperView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 || indexPath.item == section + 1 {
            return CGSize(width: self.frame.width * 0.5, height: collectionView.frame.height)
        }
        return CGSize(width: CGFloat(configure.gap) * CGFloat(configure.unitInterval), height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
