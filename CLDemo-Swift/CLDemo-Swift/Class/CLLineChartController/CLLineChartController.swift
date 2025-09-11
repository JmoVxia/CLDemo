//
//  CLLineChartController.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2022/11/11.
//

import UIKit

class CLLineChartController: CLController {
    lazy var lineChartView: CLLineChartView = {
        let view = CLLineChartView()
        view.dataSource = self
        view.backgroundColor = .random
        return view
    }()

    var points = [CGPoint]()
    var points1 = [CGPoint]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 250, height: 150))
        }

        for i in 0 ..< 40 {
            points.append(.init(x: CGFloat(i) + 0.5, y: CGFloat.random(in: 7000 ... 7500)))
            points1.append(.init(x: CGFloat(i) + 0.5, y: CGFloat.random(in: 7500 ... 8000)))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.lineChartView.reload()
        }
    }
}

extension CLLineChartController: CLLineChartViewDataSource {
    func chartView(_ chartView: CLLineChartView, gradientColorsForLineAt line: Int) -> [CGColor] {
        ["#00FFFF".cgColor, "#00FFFF".uiColor.withAlphaComponent(0.0).cgColor]
    }

    func numberOfXTicks(in view: CLLineChartView) -> Int {
        6
    }

    func numberOfYTicks(in view: CLLineChartView) -> Int {
        6
    }

    func numberOfLines(in view: CLLineChartView) -> Int {
        1
    }

    func chartView(_ chartView: CLLineChartView, numberOfPointsInLine line: Int) -> [CGPoint] {
        if line == 0 {
            points
        } else {
            points1
        }
    }

    func chartView(_ chartView: CLLineChartView, layerForLineAt line: Int) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = "#00FFFF".cgColor
        return layer
    }

    func axisInX(in view: CLLineChartView) -> (min: CGFloat, max: CGFloat) {
        (0, 40)
    }

    func axisInY(in view: CLLineChartView) -> (min: CGFloat, max: CGFloat) {
        (7000, 8000)
    }

    func size(in view: CLLineChartView) -> CGSize {
        CGSize(width: 250, height: 150)
    }
}

extension CLLineChartController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        points.removeAll()
        points1.removeAll()
        for i in 0 ..< 40 {
            points.append(.init(x: CGFloat(i) + 0.5, y: CGFloat.random(in: 7000 ... 7500)))
            points1.append(.init(x: CGFloat(i) + 0.5, y: CGFloat.random(in: 7500 ... 8000)))
        }
        lineChartView.reload()
    }
}
