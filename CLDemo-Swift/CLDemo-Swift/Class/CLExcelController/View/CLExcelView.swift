//
//  CLExcelView.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/4/6.
//

import UIKit

// MARK: - JmoVxia---枚举

extension CLExcelView {}

// MARK: - JmoVxia---类-属性

class CLExcelView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var layout: CLCollectionExcelLayout = {
        let layout = CLCollectionExcelLayout()
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: self.layout)
        view.backgroundColor = .white
        view.isDirectionalLockEnabled = true
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = true
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.register(CLCollectionExcelCell.self, forCellWithReuseIdentifier: "CLCollectionExcelCell")
        return view
    }()

    private var initialOffset = CGPoint.zero
    /// 数据源
    var dataList = [[String]]()

    var size = [[CGSize]]()
}

// MARK: - JmoVxia---布局

private extension CLExcelView {
    func initSubViews() {
        addSubview(collectionView)
    }

    func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---override

extension CLExcelView {}

// MARK: - JmoVxia---objc

@objc private extension CLExcelView {}

// MARK: - JmoVxia---私有方法

private extension CLExcelView {
    func calculateSize(for array: [[String]]) -> [[CGSize]] {
        var labelDictionary: [String: UILabel] = [:]
        var maxWidthDictionary: [Int: CGFloat] = [:]
        var maxHeightDictionary: [Int: CGFloat] = [:]

        for (rowIndex, row) in array.enumerated() {
            var columnSizes: [CGSize] = []
            for (columnIndex, string) in row.enumerated() {
                var label: UILabel
                if let existedLabel = labelDictionary[string] {
                    label = existedLabel
                } else {
                    label = UILabel()
                    label.text = string
                    label.numberOfLines = 0
                    label.font = .mediumPingFangSC(16)
                    labelDictionary[string] = label
                }

                var size = label.sizeThatFits(CGSize(width: screenWidth * 0.35, height: CGFloat.greatestFiniteMagnitude))
                size = CGSize(width: ceil(size.width + 50), height: ceil(size.height) + 20)

                columnSizes.append(size)

                if let maxWidth = maxWidthDictionary[columnIndex] {
                    maxWidthDictionary[columnIndex] = max(maxWidth, size.width)
                } else {
                    maxWidthDictionary[columnIndex] = size.width
                }
            }
            if let maxHeight = columnSizes.map(\.height).max() {
                maxHeightDictionary[rowIndex] = maxHeight
            }
        }

        var resultArray: [[CGSize]] = []
        for (rowIndex, row) in array.enumerated() {
            var rowSizes: [CGSize] = []
            for columnIndex in 0 ..< row.count {
                let size = CGSize(width: maxWidthDictionary[columnIndex]!, height: maxHeightDictionary[rowIndex]!)
                rowSizes.append(size)
            }
            let maxWidth = rowSizes.reduce(into: CGFloat.zero) { $0 += $1.width }
            if maxWidth < screenWidth - 20, let frist = rowSizes.first {
                rowSizes[0] = CGSize(width: frist.width + (screenWidth - 20 - maxWidth), height: frist.height)
            }
            resultArray.append(rowSizes)
        }

        return resultArray
    }
}

// MARK: - JmoVxia---公共方法

extension CLExcelView {
    func reloadData() {
        size = calculateSize(for: dataList)
        collectionView.reloadData()
    }
}

extension CLExcelView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLCollectionExcelCell", for: indexPath)
        if let excelCell = cell as? CLCollectionExcelCell {
            excelCell.titleLabel.text = dataList[indexPath.section][indexPath.row]
            excelCell.titleLabel.textColor = indexPath.row == .zero ? "#FF842B".uiColor : "#6B6F6A".uiColor
            excelCell.backgroundColor = indexPath.section == 0 ? "#FFF7EE".uiColor : .white
            excelCell.lineTop.isHidden = indexPath.section != .zero
            excelCell.lineLeft.isHidden = indexPath.row != .zero
        }
        return cell
    }
}

extension CLExcelView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        size[indexPath.section][indexPath.row]
    }
}

extension CLExcelView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        initialOffset = scrollView.contentOffset
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isVertical = abs(scrollView.contentOffset.x - initialOffset.x) >= abs(scrollView.contentOffset.y - initialOffset.y)
        if isVertical {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: initialOffset.y)
        } else {
            scrollView.contentOffset = CGPoint(x: initialOffset.x, y: scrollView.contentOffset.y)
        }
    }
}
