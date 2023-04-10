//
//  CLHoneycombView.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/16.
//

import SnapKit
import UIKit

// MARK: - JmoVxia---复用池

extension CLHoneycombView {
    class CLHoneycombReusePool {
        private var cacheCells = [String: NSMutableSet]()
        private let semaphore: DispatchSemaphore = {
            let semap = DispatchSemaphore(value: 0)
            semap.signal()
            return semap
        }()

        func pushCell(_ cell: CLHoneycombCell, forReuseIdentifier identifier: String) {
            semaphore.wait()
            defer {
                semaphore.signal()
            }

            if cacheCells[identifier] == nil {
                cacheCells[identifier] = []
            }
            cacheCells[identifier]?.add(cell)
        }

        func popCell(forReuseIdentifier identifier: String) -> CLHoneycombCell? {
            semaphore.wait()
            defer {
                semaphore.signal()
            }
            if let cell = cacheCells[identifier]?.anyObject() as? CLHoneycombCell {
                cacheCells[identifier]?.remove(cell)
                return cell
            }
            return nil
        }

        func removeAll() {
            semaphore.wait()
            defer {
                semaphore.signal()
            }
            cacheCells.removeAll()
        }
    }
}

// MARK: - JmoVxia---属性

class CLHoneycombView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 代理
    weak var delegate: CLHoneycombDelegate? {
        didSet {
            contentView.delegate = delegate
        }
    }

    /// 数据源
    weak var dataSource: CLHoneycombDataSource?
    /// 内边距
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            if contentInset != oldValue {
                contentView.contentInset = contentInset
            }
        }
    }

    /// 行间距
    var itemRowSpacing: CGFloat = 0
    /// 列间距
    var itemColumnSpacing: CGFloat = 0
    /// 复用池
    private let reusePool = CLHoneycombReusePool()
    /// 有效区域
    private var validRect: CGRect = .zero
    /// 总个数
    private var items: Int = 0
    /// 每行个数
    private var itemsPerRow: Int = 0
    /// 当前高亮标记
    private var currentHighlightedIndex: Int = -1
    /// item宽度
    private(set) var itemWidth: CGFloat = 0
    /// item边长
    private(set) var itemSideLength: CGFloat = 0
    /// item高度
    private(set) var itemHeight: CGFloat = 0
    /// 每组个数
    private(set) var numbersPerGroup: Int = 0
    /// 组数
    private(set) var numberOfGroups: Int = 0
    /// 每组高度
    private(set) var heightOfGroup: CGFloat = 0
    /// 当前显示的Cell
    private(set) var visibleCells = [Int: CLHoneycombCell]()
    /// 注册池
    private var registeredCellTypes = [String: CLHoneycombCell.Type]()
    /// 所有cell的Rect
    private var cellRects = [Int: CGRect]()
    /// 当前显示的Cell的Rect
    private var visibleCellRects: [(Int, CGRect)] {
        return cellRects.filter { displayingContentRect.containsVisibleRect($0.1) }
    }

    /// 显示内容区域
    private var displayingContentRect: CGRect {
        return CGRect(x: contentView.contentOffset.x, y: contentView.contentOffset.y, width: bounds.width, height: bounds.height)
    }

    /// 滑动容器
    private lazy var contentView: CLHoneycombContentView = {
        let view = CLHoneycombContentView()
        view.layoutSubviewsCallback = { [weak self] in
            guard let self = self else { return }
            self.invalidateLayout()
        }
        return view
    }()
}

// MARK: - JmoVxia---UI相关

private extension CLHoneycombView {
    func initUI() {
        addSubview(contentView)
    }

    func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---内部布局

private extension CLHoneycombView {
    func invalidateLayout() {
        guard let delegation = delegate, let dataSource = dataSource else { return }
        cellRects.filter { displayingContentRect.containsVisibleRect($0.1) && visibleCells[$0.0] == nil }.forEach { i, cellRect in
            let cell = dataSource.honeycombView(self, cellForRowAtIndex: i)
            cell.frame = cellRect
            delegation.honeycombView(self, willDisplayCell: cell, forIndex: i)
            contentView.addSubview(cell)
            visibleCells[i] = cell
        }
        visibleCells.filter { !displayingContentRect.containsVisibleRect(cellRects[$0.0] ?? .zero) }.forEach { index, cell in
            cell.removeFromSuperview()
            cell.setHighlighted(false)
            cell.setSelected(false)
            visibleCells[index] = nil
            delegation.honeycombView(self, didEndDisplayingCell: cell, forIndex: index)
            reusePool.pushCell(cell, forReuseIdentifier: cell.identifier)
        }
    }
}

// MARK: - JmoVxia---高亮相关

private extension CLHoneycombView {
    func highlightItemAtIndex(_ index: Int, explicit: Bool) {
        guard currentHighlightedIndex != index else { return }
        visibleCells[currentHighlightedIndex]?.setHighlighted(false)
        currentHighlightedIndex = index
        visibleCells[currentHighlightedIndex]?.setHighlighted(true)
        if explicit {
            delegate?.honeycombView(self, didHighlightItemAtIndex: index)
        }
    }

    func unhighlightItemAtIndex(_ index: Int) {
        guard currentHighlightedIndex == index else { return }
        visibleCells[currentHighlightedIndex]?.setHighlighted(false)
        delegate?.honeycombView(self, didUnhighlightItemAtIndex: currentHighlightedIndex)
        currentHighlightedIndex = -1
    }
}

// MARK: - JmoVxia---选中相关

private extension CLHoneycombView {
    func selectItemAtIndex(_ index: Int) {
        visibleCells[index]?.setSelected(true)
        delegate?.honeycombView(self, didSelectItemAtIndex: index)
    }

    func deselectItemAtIndex(_ index: Int) {
        visibleCells[index]?.setSelected(false)
        delegate?.honeycombView(self, didDeselectItemAtIndex: index)
    }
}

// MARK: - JmoVxia---点击相关

extension CLHoneycombView {
    private func centerForRect(_ rect: CGRect) -> CGPoint {
        return CGPoint(x: (rect.maxX - rect.minX) * 0.5 + rect.origin.x, y: (rect.maxY - rect.minY) * 0.5 + rect.origin.y)
    }

    private func distanceBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        let dy = p1.y - p2.y
        let dx = p1.x - p2.x
        return sqrt(pow(dy, 2) + pow(dx, 2))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touchPoint = touches.first?.location(in: contentView) else { return }

        let containingRects = visibleCellRects.filter { $0.1.contains(touchPoint) }
        if containingRects.count >= 2 {
            var nearestIndexRect = containingRects.first!
            for currentIndexRect in containingRects where distanceBetween(centerForRect(currentIndexRect.1), touchPoint) < distanceBetween(centerForRect(nearestIndexRect.1), touchPoint) {
                nearestIndexRect = currentIndexRect
            }
            let indexForHighlight = nearestIndexRect.0
            let explicit = delegate?.honeycombView(self, shouldHightlightItemAtIndex: indexForHighlight) ?? true
            highlightItemAtIndex(indexForHighlight, explicit: explicit)
        } else if containingRects.count == 1 {
            let indexForHighlight = containingRects.first!.0
            let explicit = delegate?.honeycombView(self, shouldHightlightItemAtIndex: indexForHighlight) ?? true
            highlightItemAtIndex(indexForHighlight, explicit: explicit)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let index = currentHighlightedIndex
        guard index >= 0, let honeycomDelegate = delegate else { return }

        unhighlightItemAtIndex(index)
        let isSelected = visibleCells[index]?.isSelected ?? false
        if isSelected, honeycomDelegate.honeycombView(self, shouldDeselectItemAtIndex: index) {
            deselectItemAtIndex(index)
        } else if !isSelected, honeycomDelegate.honeycombView(self, shouldSelectItemAtIndex: index) {
            selectItemAtIndex(index)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard currentHighlightedIndex >= 0 else { return }
        unhighlightItemAtIndex(currentHighlightedIndex)
    }
}

// MARK: - JmoVxia---cell相关

extension CLHoneycombView {
    /// 注册Cell
    func register(_ cellClass: CLHoneycombCell.Type, forCellWithReuseIdentifier identifier: String) {
        registeredCellTypes[identifier] = cellClass
    }

    /// 复用cell
    func dequeueReusableCell(withReuseIdentifier identifier: String) -> CLHoneycombCell? {
        if let cell = reusePool.popCell(forReuseIdentifier: identifier) {
            return cell
        } else if let registeredCellType = registeredCellTypes[identifier] {
            return registeredCellType.init(reuseIdentifier: identifier)
        } else {
            return nil
        }
    }
}

// MARK: - JmoVxia---刷新

extension CLHoneycombView {
    /// 刷新数据
    func reloadData() {
        guard let items = dataSource?.honeycombViewNumberOfItems(self),
              let itemsPerRow = dataSource?.honeycombViewNumberOfItemsPerRow(self),
              items > 0,
              itemsPerRow > 1
        else {
            return
        }
        self.items = items
        self.itemsPerRow = itemsPerRow

        setNeedsLayout()
        layoutIfNeeded()

        subviews.forEach { ($0 as? CLHoneycombCell)?.removeFromSuperview() }
        cellRects.removeAll()
        visibleCells.removeAll()
        reusePool.removeAll()

        validRect = CGRect(x: displayingContentRect.origin.x + contentView.contentInset.left, y: 0, width: displayingContentRect.width - contentView.contentInset.left - contentView.contentInset.right, height: displayingContentRect.height)

        itemWidth = (validRect.width - itemColumnSpacing * CGFloat(itemsPerRow - 1)) / CGFloat(itemsPerRow)
        itemSideLength = itemWidth / sqrt(3)
        itemHeight = itemSideLength * 2

        numbersPerGroup = itemsPerRow + itemsPerRow - 1
        numberOfGroups = (items + numbersPerGroup - 1) / numbersPerGroup
        heightOfGroup = itemSideLength + itemHeight + 2 * itemRowSpacing

        for i in 0 ..< items {
            let groupIndex: Int = i / numbersPerGroup
            let itemIndexInGroup: Int = i % numbersPerGroup
            let isFirstLine: Bool = itemIndexInGroup < Int(numbersPerGroup / 2)
            let itemIndexInLine: Int = isFirstLine ? itemIndexInGroup : itemIndexInGroup - Int(numbersPerGroup / 2)
            let x = itemWidth * (CGFloat(itemIndexInLine) + (isFirstLine ? 0.5 : 0)) + CGFloat(itemIndexInLine) * itemColumnSpacing + (isFirstLine ? itemColumnSpacing * 0.5 : 0)
            let y = itemHeight * (isFirstLine ? 0 : 0.75) + heightOfGroup * CGFloat(groupIndex) + (isFirstLine ? 0 : itemRowSpacing)
            let cellRect = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            cellRects[i] = cellRect
        }
        if numbersPerGroup <= 0 || numberOfGroups == 0 {
            contentView.contentSize = validRect.size
        } else {
            let lastGroupHasTwoLine: Bool = ((items - 1) % numbersPerGroup) >= Int(numbersPerGroup / 2)
            contentView.contentSize = validRect.union(CGRect(x: 0, y: 0, width: validRect.width, height: CGFloat(numberOfGroups) * heightOfGroup + (lastGroupHasTwoLine ? itemHeight * 0.25 : -itemSideLength))).size
        }
    }
}
