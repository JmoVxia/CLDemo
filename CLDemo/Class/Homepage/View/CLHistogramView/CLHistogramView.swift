//
//  CLHistogramView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/8.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLHistogramView: UIView {
    var isOpen: Bool = false
    private var leftRightEdge: CGFloat = 60
    private var middleSpace: CGFloat = 10
    private var topToolBarHeight: CGFloat = 36
    private var bottomToolBarHeight: CGFloat = 30
    private var lineWidth: CGFloat = 0.5
    private var rowHeight: CGFloat = 20
    private var minRow: Int = 7
    private var controlRow: Int = 9
    private var maxRow: Int = 12
    private var maxValue: CGFloat = 1.8
    private var lessValue: CGFloat = 0.8
    private var nomalValue: CGFloat = 1.0
    private var exceedValue: CGFloat = 1.5
    private lazy var lessLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.green.cgColor
        layer.lineWidth = lineWidth
        layer.lineCap = .round
        layer.lineDashPattern = [4, 3]
        return layer
    }()
    private lazy var nomalLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.orange.cgColor
        layer.lineWidth = lineWidth
        return layer
    }()
    private lazy var exceedLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = lineWidth
        return layer
    }()
    private lazy var lessLabel: UILabel = {
        let view = UILabel()
        view.textColor = .green
        view.font = PingFangSCMedium(10)
        view.textAlignment = .center
        view.text = "80%"
        return view
    }()
    private lazy var nomalLabel: UILabel = {
        let view = UILabel()
        view.textColor = .orange
        view.font = PingFangSCMedium(10)
        view.textAlignment = .center
        view.text = "100%"
        return view
    }()
    private lazy var exceedLabel: UILabel = {
        let view = UILabel()
        view.textColor = .red
        view.font = PingFangSCMedium(10)
        view.textAlignment = .center
        view.text = "150%"
        return view
    }()
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = PingFangSCMedium(14)
        view.textAlignment = .right
        view.text = "名称"
        return view
    }()
    private lazy var totalLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = PingFangSCMedium(14)
        view.textAlignment = .left
        view.text = "总计"
        return view
    }()
    private lazy var topToolBar: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var tableview: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.rowHeight = rowHeight
        view.isScrollEnabled = false
        view.register(CLHistogramCell.classForCoder(), forCellReuseIdentifier: "CLHistogramCell")
        return view
    }()
    private lazy var bottomToolBar: UIControl = {
        let view = UIControl()
        view.addTarget(self, action: #selector(clickUnfoldAction), for: .touchUpInside)
        return view
    }()
    private lazy var nomalIndexView: CLHistogramIndexView = {
        let view = CLHistogramIndexView()
        view.indexView.backgroundColor = .green
        view.indexLabel.text = "正常"
        return view
    }()
    private lazy var exceedIndexView: CLHistogramIndexView = {
        let view = CLHistogramIndexView()
        view.indexView.backgroundColor = .red
        view.indexLabel.text = "超出"
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
        DispatchQueue.main.async {
            self.drawPercentLayer()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        lessLayer.frame = bounds
        nomalLayer.frame = bounds
        exceedLayer.frame = bounds
    }
}
private extension CLHistogramView {
    func initUI() {
        layer.borderColor = UIColor.red.withAlphaComponent(0.4).cgColor
        layer.borderWidth = 1
        backgroundColor = .white
        addSubview(topToolBar)
        addSubview(tableview)
        addSubview(bottomToolBar)
        topToolBar.addSubview(nameLabel)
        topToolBar.addSubview(lessLabel)
        topToolBar.addSubview(nomalLabel)
        topToolBar.addSubview(exceedLabel)
        topToolBar.addSubview(totalLabel)
        topToolBar.addSubview(nomalIndexView)
        topToolBar.addSubview(exceedIndexView)
    }
    func makeConstraints() {
        topToolBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(topToolBarHeight)
        }
        bottomToolBar.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(bottomToolBarHeight)
        }
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topToolBar.snp.bottom)
            make.bottom.equalTo(bottomToolBar.snp.top)
            make.height.equalTo(rowHeight * CGFloat(minRow))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(leftRightEdge)
            make.left.centerY.equalToSuperview()
        }
        lessLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalTo(topToolBar.snp.right).multipliedBy(lessValue / maxValue).offset(-(leftRightEdge + middleSpace) * 2 * (lessValue / maxValue) + (leftRightEdge + middleSpace + lineWidth * 0.5))
        }
        nomalLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(lessLabel.snp.top)
            make.centerX.equalTo(topToolBar.snp.right).multipliedBy(nomalValue / maxValue).offset(-(leftRightEdge + middleSpace) * 2 * (nomalValue / maxValue) + (leftRightEdge + middleSpace + lineWidth * 0.5))
        }
        exceedLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(nomalLabel.snp.top)
            make.centerX.equalTo(topToolBar.snp.right).multipliedBy(exceedValue / maxValue).offset(-(leftRightEdge + middleSpace) * 2 * (exceedValue / maxValue) + (leftRightEdge + middleSpace + lineWidth * 0.5))
        }
        totalLabel.snp.makeConstraints { (make) in
            make.left.equalTo(snp.right).offset(-leftRightEdge)
            make.width.equalTo(leftRightEdge)
            make.centerY.equalToSuperview()
        }
        nomalIndexView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(middleSpace)
            make.centerY.equalToSuperview()
        }
        exceedIndexView.snp.makeConstraints { (make) in
            make.left.equalTo(nomalIndexView.snp.right).offset(middleSpace)
            make.centerY.equalToSuperview()
        }
    }
}
private extension CLHistogramView {
    @objc func clickUnfoldAction() {
        animationPathLayer()
    }
}
private extension CLHistogramView {
    func drawPercentLayer() {
        lessLayer.path = lessPath.cgPath
        layer.addSublayer(lessLayer)
        
        nomalLayer.path = nomalPath.cgPath
        layer.addSublayer(nomalLayer)
        
        exceedLayer.path = exceedPath.cgPath
        layer.addSublayer(exceedLayer)
    }
    var lessPath: UIBezierPath {
        let path = UIBezierPath()
        let x: CGFloat = (bounds.width - (leftRightEdge + middleSpace) * 2) * (lessValue / maxValue) + (leftRightEdge + middleSpace - lineWidth * 0.5)
        path.move(to: CGPoint(x: x, y: topToolBarHeight))
        path.addLine(to: CGPoint(x: x, y: bounds.maxY - bottomToolBarHeight - (isOpen ? (CGFloat(maxRow - controlRow) * rowHeight) : 0)))
        return path
    }
    var nomalPath: UIBezierPath {
        let path = UIBezierPath()
        let x = (bounds.width - (leftRightEdge + middleSpace) * 2) * (nomalValue / maxValue) + (leftRightEdge + middleSpace - lineWidth * 0.5)
        path.move(to: CGPoint(x: x, y: topToolBarHeight - 12))
        path.addLine(to: CGPoint(x: x, y: bounds.maxY - bottomToolBarHeight - (isOpen ? (CGFloat(maxRow - controlRow) * rowHeight) : 0)))
        return path
    }
    var exceedPath: UIBezierPath {
        let path = UIBezierPath()
        let x = (bounds.width - (leftRightEdge + middleSpace) * 2) * (exceedValue / maxValue) + (leftRightEdge + middleSpace - lineWidth * 0.5)
        path.move(to: CGPoint(x: x, y: topToolBarHeight - 24))
        path.addLine(to: CGPoint(x: x, y: bounds.maxY - bottomToolBarHeight - (isOpen ? (CGFloat(maxRow - controlRow) * rowHeight) : 0)))
        return path
    }
}
extension CLHistogramView {
    func animationPathLayer(_ duration: TimeInterval = 0.35) {
        tableview.snp.updateConstraints { (make) in
            make.height.equalTo(isOpen ? rowHeight * CGFloat(minRow) : rowHeight * CGFloat(maxRow))
        }
        self.isOpen.toggle()
        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear]) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        } completion: { (_) in
            self.lessLayer.path = self.lessPath.cgPath
            self.nomalLayer.path = self.nomalPath.cgPath
            self.exceedLayer.path = self.exceedPath.cgPath
        }
        do {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = duration
            animation.fromValue = lessLayer.path
            animation.toValue = lessPath.cgPath
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            lessLayer.add(animation, forKey: nil)
        }
        do {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = duration
            animation.fromValue = nomalLayer.path
            animation.toValue = nomalPath.cgPath
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            nomalLayer.add(animation, forKey: nil)
        }
        do {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = duration
            animation.fromValue = exceedLayer.path
            animation.toValue = exceedPath.cgPath
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            exceedLayer.add(animation, forKey: nil)
        }
    }
}
extension CLHistogramView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxRow
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "CLHistogramCell", for: indexPath) as! CLHistogramCell
        let morning = NSDecimalNumber(floatLiteral: Double(Float.random(in: 0.1...0.6)))
        let noon = NSDecimalNumber(floatLiteral: Double(Float.random(in: 0.1...0.5)))
        let night = NSDecimalNumber(floatLiteral: Double(Float.random(in: 0.1...0.5)))
        let additional = NSDecimalNumber(floatLiteral: Double(Float.random(in: 0.1...0.5)))
        cell.name = "指标 \(indexPath.row)"
        cell.item = CLHistogramCell.CLHistogramItem(morning: morning, noon: noon, night: night, additional: additional)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}
extension CLHistogramView: UITableViewDelegate {
    
}
