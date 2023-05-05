//
//  HexagonalView.swift
//  Hexacon
//
//  Created by Gautier Gdx on 05/02/16.
//  Copyright © 2016 Gautier. All rights reserved.
//

import UIKit

protocol HexagonalViewDelegate: AnyObject {
    /**
     This method is called when the user has selected a view

     - parameter hexagonalView: The HexagonalView we are targeting
     - parameter index:         The current Index
     */
    func hexagonalView(_ hexagonalView: HexagonalView, didSelectItemAtIndex index: Int)

    /**
     This method is called when the HexagonalView will center on an item, it gives you the new value of lastFocusedViewIndex

     - parameter hexagonalView: The HexagonalView we are targeting
     - parameter index:         The current Index
     */
    func hexagonalView(_ hexagonalView: HexagonalView, willCenterOnIndex index: Int)
}

extension HexagonalViewDelegate {
    func hexagonalView(_ hexagonalView: HexagonalView, didSelectItemAtIndex index: Int) {}
    func hexagonalView(_ hexagonalView: HexagonalView, willCenterOnIndex index: Int) {}
}

protocol HexagonalViewDataSource: AnyObject {
    /**
     Return the number of items the view will contain

     - parameter hexagonalView: The HexagonalView we are targeting

     - returns: The number of items
     */
    func numberOfItemInHexagonalView(_ hexagonalView: HexagonalView) -> Int

    /**
     Return a image to be displayed at index

     - parameter hexagonalView: The HexagonalView we are targeting
     - parameter index:         The current Index

     - returns: The image we want to display
     */
    func hexagonalView(_ hexagonalView: HexagonalView, imageForIndex index: Int) -> UIImage?

    /**
     Return a view to be displayed at index, the view will be transformed in an image before being displayed

     - parameter hexagonalView: The HexagonalView we are targeting
     - parameter index:         The current Index

     - returns: The view we want to display
     */
    func hexagonalView(_ hexagonalView: HexagonalView, viewForIndex index: Int) -> UIView?
}

extension HexagonalViewDataSource {
    func hexagonalView(_ hexagonalView: HexagonalView, imageForIndex index: Int) -> UIImage? { nil }
    func hexagonalView(_ hexagonalView: HexagonalView, viewForIndex index: Int) -> UIView? { nil }
}

final class HexagonalView: UIScrollView {
    // MARK: - subviews

    private lazy var contentView = UIView()

    // MARK: - data

    /**
     An object that supports the HexagonalViewDataSource protocol and can provide views or images to configures the HexagonalView.
     */
    weak var hexagonalDataSource: HexagonalViewDataSource?

    /**
     An object that supports the HexagonalViewDelegate protocol and can respond to HexagonalView events.
     */
    weak var hexagonalDelegate: HexagonalViewDelegate?

    /**
     The index of the view where the HexagonalView is or was centered on.
     */
    var lastFocusedViewIndex: Int = 0

    /**
     the appearance is used to configure the global apperance of the layout and the HexagonalItemView
     */
    var itemAppearance: HexagonalItemViewAppearance

    // we are using a zoom cache setted to 1 to make the snap work even if the user haven't zoomed yet
    private var zoomScaleCache: CGFloat = 1

    // ArrayUsed to contain all the view in the Hexagonal grid
    private var viewsArray = [HexagonalItemView]()

    // manager to create the hexagonal grid
    private var hexagonalPattern: HexagonalPattern!

    // used to snap the view after scroll
    private var centerOnEndScroll = false

    // MARK: - init

    init(frame: CGRect, itemAppearance: HexagonalItemViewAppearance) {
        self.itemAppearance = itemAppearance
        super.init(frame: frame)

        setUpView()
    }

    override convenience init(frame: CGRect) {
        self.init(frame: frame, itemAppearance: HexagonalItemViewAppearance.defaultAppearance())
    }

    required init?(coder aDecoder: NSCoder) {
        itemAppearance = HexagonalItemViewAppearance.defaultAppearance()
        super.init(coder: aDecoder)

        setUpView()
    }

    func setUpView() {
        // configure scrollView
        contentInsetAdjustmentBehavior = .never
        delaysContentTouches = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        bouncesZoom = false
        decelerationRate = .fast
        delegate = self
        minimumZoomScale = 0.2
        maximumZoomScale = 2

        // add contentView
        addSubview(contentView)
    }

    // MARK: - configuration methods

    private func createHexagonalGrid() {
        // instantiate the hexagonal pattern with the number of views
        hexagonalPattern = HexagonalPattern(size: viewsArray.count, itemSpacing: itemAppearance.itemSpacing, itemSize: itemAppearance.itemSize)
        hexagonalPattern.repositionCenter = { [weak self] center, ring, index in
            self?.positionAndAnimateItemView(forCenter: center, ring: ring, index: index)
        }

        // set the contentView frame with the theorical size of th hexagonal grid
        let contentViewSize = hexagonalPattern.sizeForGridSize()
        contentView.bounds = CGRect(x: 0, y: 0, width: contentViewSize, height: 1.5 * contentViewSize)
        contentView.center = center

        // start creating hte grid
        hexagonalPattern.createGrid(FromCenter: CGPoint(x: contentView.frame.width / 2, y: contentView.frame.height / 2))
    }

    private func createHexagonalViewItem(index: Int) -> HexagonalItemView {
        // instantiate the userView with the user

        var itemView: HexagonalItemView

        if let image = hexagonalDataSource?.hexagonalView(self, imageForIndex: index) {
            itemView = HexagonalItemView(image: image, appearance: itemAppearance)
        } else {
            let view = (hexagonalDataSource?.hexagonalView(self, viewForIndex: index))!
            itemView = HexagonalItemView(view: view)
        }

        itemView.frame = CGRect(x: 0, y: 0, width: itemAppearance.itemSize, height: itemAppearance.itemSize)
//        itemView.setupHexagonMask(lineWidth: itemAppearance.itemBorderWidth, color: .red, cornerRadius: 0)
        itemView.isUserInteractionEnabled = true
        // setting the delegate
        itemView.delegate = self

        // adding index in order to retrive the view later
        itemView.index = index

        if itemAppearance.animationType != .None {
            // setting the scale to 0 to perform lauching animation
            itemView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }

        // add to content view
        contentView.addSubview(itemView)
        return itemView
    }

    private func positionAndAnimateItemView(forCenter center: CGPoint, ring: Int, index: Int) {
        guard itemAppearance.animationType != .None else { return }

        // set the new view's center
        let view = viewsArray[index]
        view.center = CGPoint(x: center.x, y: center.y)

        let animationIndex = Double(itemAppearance.animationType == .Spiral ? index : ring)

        // make a pop animation
        UIView.animate(withDuration: 0.3, delay: TimeInterval(animationIndex * itemAppearance.animationDuration), usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: { () in
            view.transform = .identity
        }, completion: nil)
    }

    private func transformView(view: HexagonalItemView) {
        let spacing = itemAppearance.itemSize + itemAppearance.itemSpacing / 2

        // convert the ivew rect in the contentView coordinate
        var frame = convert(view.frame, from: view.superview)
        // substract content offset to it
        frame.origin.x -= contentOffset.x
        frame.origin.y -= contentOffset.y

        // retrieve the center
        let center = CGPoint(x: frame.midX, y: frame.midY)
        let distanceToBeOffset = spacing * zoomScaleCache
        let distanceToBorder = getDistanceToBorder(center: center, distanceToBeOffset: distanceToBeOffset, insets: contentInset)

        // if we are close to a border
        if distanceToBorder < distanceToBeOffset * 2 {
            // if ere are out of bound
            if distanceToBorder < CGFloat(-Int(spacing * 2.5)) {
                // hide the view
                view.transform = CGAffineTransform(scaleX: 0, y: 0)
            } else {
                // find the new scale
                var scale = max(distanceToBorder / (distanceToBeOffset * 2), 0)
                scale = 1 - pow(1 - scale, 2)

                // transform the view
                view.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        } else {
            view.transform = .identity
        }
    }

    private func centerScrollViewContents() {
        let boundsSize = bounds.size
        var contentsFrame = contentView.frame

        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }

        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        contentView.frame = contentsFrame
    }

    private func getDistanceToBorder(center: CGPoint, distanceToBeOffset: CGFloat, insets: UIEdgeInsets) -> CGFloat {
        let size = bounds.size
        var distanceToBorder: CGFloat = size.width

        // check if the view is close to the left
        // changing the distance to border and the offset accordingly
        let leftDistance = center.x - insets.left
        if leftDistance < distanceToBeOffset, leftDistance < distanceToBorder {
            distanceToBorder = leftDistance
        }

        // same for top
        let topDistance = center.y - insets.top
        if topDistance < distanceToBeOffset, topDistance < distanceToBorder {
            distanceToBorder = topDistance
        }

        // same for right
        let rightDistance = size.width - center.x - insets.right
        if rightDistance < distanceToBeOffset, rightDistance < distanceToBorder {
            distanceToBorder = rightDistance
        }

        // same for bottom
        let bottomDistance = size.height - center.y - insets.bottom
        if bottomDistance < distanceToBeOffset, bottomDistance < distanceToBorder {
            distanceToBorder = bottomDistance
        }

        return distanceToBorder * 2
    }

    private func centerOnIndex(index: Int, zoomScale: CGFloat) {
        guard centerOnEndScroll else { return }
        centerOnEndScroll = false

        // calling delegate
        hexagonalDelegate?.hexagonalView(self, willCenterOnIndex: index)

        // the view to center
        let view = viewsArray[Int(index)]

        // find the rect of the view in the contentView scale
        let rectInSelfSpace = HexagonalView.rectInContentView(point: view.center, zoomScale: zoomScale, size: bounds.size)
        scrollRectToVisible(rectInSelfSpace, animated: true)
    }

    // MARK: - methods

    /**
     This function load or reload all the view from the dataSource and refreshes the display
     */
    func reloadData() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        viewsArray = [HexagonalItemView]()

        guard let datasource = hexagonalDataSource else { return }

        let numberOfItems = datasource.numberOfItemInHexagonalView(self)

        guard numberOfItems > 0 else { return }

        for index in 0 ... numberOfItems {
            viewsArray.append(createHexagonalViewItem(index: index))
        }

        createHexagonalGrid()
    }

    /**
     retrieve the HexagonalItemView from the HexagonalView if it's exist

     - parameter index: the current index of the HexagonalItemView

     - returns: an optionnal HexagonalItemView
     */
    func viewForIndex(index: Int) -> HexagonalItemView? {
        guard index < viewsArray.count else { return nil }

        return viewsArray[index]
    }

    // MARK: - class methods

    private static func rectInContentView(point: CGPoint, zoomScale: CGFloat, size: CGSize) -> CGRect {
        let center = CGPoint(x: point.x * zoomScale, y: point.y * zoomScale)

        return CGRect(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5, width: size.width, height: size.height)
    }

    private static func closestIndexToContentViewCenter(contentViewCenter: CGPoint, currentIndex: Int, views: [UIView]) -> Int {
        var hasItem = false
        var distance: CGFloat = 0
        var index = currentIndex

        views.enumerated().forEach { viewIndex, view in
            let center = view.center
            let potentialDistance = distanceBetweenPoint(point1: center, point2: contentViewCenter)

            if potentialDistance < distance || !hasItem {
                hasItem = true
                distance = potentialDistance
                index = viewIndex
            }
        }
        return index
    }

    private static func distanceBetweenPoint(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let distance = Double((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y))
        let squaredDistance = sqrt(distance)
        return CGFloat(squaredDistance)
    }
}

// MARK: - UIScrollViewDelegate

extension HexagonalView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        contentView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        zoomScaleCache = zoomScale

        // center the contentView each time we zoom
        centerScrollViewContents()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // for each view snap if close to border
        for view in viewsArray {
            transformView(view: view)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let size = bounds.size

        // the new contentView offset
        let newOffset: CGPoint = targetContentOffset.pointee

        // put proposedTargetCenter in coordinates relative to contentView
        var proposedTargetCenter = CGPoint(x: newOffset.x + size.width / 2, y: newOffset.y + size.height / 2)
        proposedTargetCenter.x /= zoomScale
        proposedTargetCenter.y /= zoomScale

        // find the closest userView relative to contentView center
        lastFocusedViewIndex = HexagonalView.closestIndexToContentViewCenter(contentViewCenter: proposedTargetCenter, currentIndex: lastFocusedViewIndex, views: viewsArray)

        // tell that we need to center on new index
        centerOnEndScroll = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // if we don't need do decelerate
        guard !decelerate else { return }

        // center the userView
        centerOnIndex(index: lastFocusedViewIndex, zoomScale: zoomScale)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // center the userView
        centerOnIndex(index: lastFocusedViewIndex, zoomScale: zoomScale)
    }
}

extension HexagonalView: HexagonalItemViewDelegate {
    func hexagonalItemViewClikedOnButton(forIndex index: Int) {
        hexagonalDelegate?.hexagonalView(self, didSelectItemAtIndex: index)
    }
}
