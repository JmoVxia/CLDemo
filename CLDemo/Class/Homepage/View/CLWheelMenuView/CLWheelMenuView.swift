//
//  CLWheelMenuView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

protocol CLWheelMenuViewDelegate: NSObjectProtocol {
    func wheelMenuView(_ view: CLWheelMenuView, didSelectIndex index: Int)
}
protocol CLWheelMenuViewDataSource: NSObjectProtocol {
    func numberOfItems(in wheelMenuView: CLWheelMenuView) -> Int
    func wheelMenuView(_ wheelMenuView: CLWheelMenuView, creatMenuCell cell: CLWheelMenuCell, forRowAtIndex index: Int)
}

class CLWheelMenuView: UIView {
    class CLWheelMenuConfigure {
        var centerBackgroundColor: UIColor = .white
        var centerRadius: CGFloat = 25
        var centerHole: CGFloat = 10
        var animationDuration: TimeInterval = 0.35
        var defaultOpen: Bool = true
        var closeImage: UIImage = #imageLiteral(resourceName: "close")
        var openImage: UIImage = #imageLiteral(resourceName: "menu")
    }
    weak var dataSource: CLWheelMenuViewDataSource?
    weak var delegate: CLWheelMenuViewDelegate?
    private (set) var configure = CLWheelMenuConfigure()
    private (set) var openMenu: Bool = true
    private (set) var selectedIndex = 0
    private var startPoint = CGPoint.zero
    private var cells = [CLWheelMenuCell]()
    private var currentAngle: CGFloat {
        let angle = 2 * CGFloat(Double.pi) / CGFloat(cells.count)
        return CGFloat(cells.count - selectedIndex) * angle
    }
    private lazy var menuLayerView: UIView = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        let view = UIView()
        view.addGestureRecognizer(pan)
        view.addGestureRecognizer(tap)
        return view
    }()
    private lazy var centerButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = configure.centerRadius
        view.backgroundColor = configure.centerBackgroundColor
        view.addTarget(self, action: #selector(centerButtonAction), for: .touchUpInside)
        return view
    }()
    init(frame: CGRect, configureCallback: ((CLWheelMenuConfigure) -> ())? = nil) {
        super.init(frame: frame)
        configureCallback?(configure)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension CLWheelMenuView {
    func initUI() {
        addSubview(menuLayerView)
        addSubview(centerButton)
    }
    func makeConstraints() {
        menuLayerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        centerButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(configure.centerRadius * 2)
        }
    }
    func creatMenuCell() {
        guard let dataSource = dataSource else {
            return
        }
        setNeedsLayout()
        layoutIfNeeded()
        let items = dataSource.numberOfItems(in: self)
        menuLayerView.subviews.forEach{ $0.removeFromSuperview() }
        let angle = 2 * CGFloat(Double.pi) / CGFloat(items)
        for index in 0..<items {
            let startAngle = CGFloat(index) * angle - angle * 0.5 - CGFloat(Double.pi * 0.5)
            let endAngle = CGFloat(index + 1) * angle - angle * 0.5 - CGFloat(Double.pi * 0.5) + 0.005
            let wheelMenuCell = CLWheelMenuCell(frame: bounds, startAngle: startAngle, endAngle: endAngle, contentsTransform: CATransform3DMakeRotation(angle * CGFloat(index), 0, 0, 1))
            wheelMenuCell.isSelected = index == selectedIndex
            menuLayerView.addSubview(wheelMenuCell)
            cells.append(wheelMenuCell)
            dataSource.wheelMenuView(self, creatMenuCell: wheelMenuCell, forRowAtIndex: index)
        }
        createHole(in: menuLayerView, radius: configure.centerRadius + configure.centerHole)
        if configure.defaultOpen {
            openMenuView(withAnimate: false)
        }else {
            closeMenuView(withAnimate: false)
        }
        setSelectedIndex(0, animated: false)
    }
    func createHole(in view : UIView, radius: CGFloat)   {
        let path = CGMutablePath()
        path.addArc(center: view.center, radius: radius, startAngle: 0.0, endAngle: 2.0 * .pi, clockwise: true)
        path.addRect(CGRect(origin: .zero, size: view.bounds.size))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        view.layer.mask = maskLayer
        view.clipsToBounds = true
    }
}
extension CLWheelMenuView {
    func reloadData() {
        creatMenuCell()
    }
    func openMenuView(withAnimate animate: Bool = true) {
        openMenu = true
        UIView.animate(withDuration: animate ? configure.animationDuration : 0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: .curveEaseInOut) {
            self.centerButton.transform = CGAffineTransform(rotationAngle: .pi * -0.5)
            self.centerButton.setImage(self.configure.closeImage, for: .normal)
            self.menuLayerView.transform = CGAffineTransform(scaleX: 1, y: 1).rotated(by: self.currentAngle)
        }
    }
    func closeMenuView(withAnimate animate: Bool = true) {
        openMenu = false
        let scale = (configure.centerRadius * 2) / bounds.width
        UIView.animate(withDuration: animate ? configure.animationDuration : 0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: .curveEaseInOut) {
            self.centerButton.transform = .identity
            self.centerButton.setImage(self.configure.openImage, for: .normal)
            self.menuLayerView.transform = CGAffineTransform(scaleX: scale, y: scale).rotated(by: self.currentAngle)
        }
    }
    func setSelectedIndex(_ index: Int, animated: Bool) {
        delegate?.wheelMenuView(self, didSelectIndex: index)
        selectedIndex = index
        let duration  = animated ? configure.animationDuration : 0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            self.menuLayerView.transform = CGAffineTransform(rotationAngle: self.currentAngle)
        } completion: { (_) in
            self.cells.enumerated().forEach { $0.element.isSelected = $0.offset == index }
        }
    }
}
@objc private extension CLWheelMenuView {
    func centerButtonAction() {
        openMenu ? closeMenuView() : openMenuView()
    }
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        switch sender.state {
        case .began:
            startPoint = location
        case .changed:
            let radian1 = -atan2(startPoint.x - menuLayerView.center.x, startPoint.y - menuLayerView.center.y)
            let radian2 = -atan2(location.x - menuLayerView.center.x, location.y - menuLayerView.center.y)
            menuLayerView.transform = menuLayerView.transform.rotated(by: radian2 - radian1)
            startPoint = location
        default:
            let angle = 2 * CGFloat(Double.pi) / CGFloat(cells.count)
            var menuViewAngle = atan2(menuLayerView.transform.b, menuLayerView.transform.a)
            if menuViewAngle < 0 {
                menuViewAngle += CGFloat(2 * Double.pi)
            }
            var index = cells.count - Int((menuViewAngle + CGFloat(Double.pi / 4)) / angle)
            if index == cells.count {
                index = 0
            }
            setSelectedIndex(index, animated: true)
        }
    }
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: menuLayerView)
        for (index, cell) in cells.enumerated() {
            if cell.path.contains(location) {
                setSelectedIndex(index, animated: true)
            }
        }
    }
}
