//
//  CLExcelController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2023/4/6.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---类-属性
class CLExcelController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    private lazy var excelView: CLExcelView = {
        let view = CLExcelView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderColor = "#FFECCB".cgColor
        view.layer.borderWidth = 1
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLExcelController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        makeConstraints()
        initData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
//MARK: - JmoVxia---布局
private extension CLExcelController {
    func initSubViews() {
        view.addSubview(excelView)
    }
    func makeConstraints() {
        excelView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(400)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLExcelController {
    func initData() {
        excelView.dataList = [
            ["权益","总数\n数量","剩余","IP","状态","状态1","状态2","状态3","状态4"],
            ["1.产品权益内容详细。","0","0","3.4.5.6","027641081087","1","0","3.4.5.6","027641081087"],
            ["2.糖尿病肾病血糖管理服务权益内容列表。","0","0","3.4.5.6","027641081087","2","0","3.4.5.6","027641081087"],
            ["3.预防为主，早期规范化慢病管理非常重要。","0","0","3.4.5.6","027641081087","3","0","3.4.5.6","027641081087"],
            ["4.中晚期可出现蛋白尿、高血压、水肿等。","0","0","3.4.5.6","027641081087","4","0","3.4.5.6","027641081087"],
            ["ces5","0","0","3.4.5.6","027641081087","5","0","3.4.5.6","027641081087"],
            ["ces6","0","0","3.4.5.6","027641081087","6","0","3.4.5.6","027641081087"],
            ["ces7","0","0","3.4.5.6","027641081087","7","0","3.4.5.6","027641081087"],
            ["ces8","0","0","3.4.5.6","027641081087","8","0","3.4.5.6","027641081087"],
            ["ces9","0","0","3.4.5.6","027641081087","9","0","3.4.5.6","027641081087"],
            ["ces10","0","0","3.4.5.6","027641081087","9","0","3.4.5.6","027641081087"],
            ["ces11","0","0","3.4.5.6","027641081087","9","0","3.4.5.6","027641081087"],
            ["ces12","0","0","3.4.5.6","027641081087","9","0","3.4.5.6","027641081087"],
            ["ces13","0","0","3.4.5.6","027641081087","9","0","3.4.5.6","027641081087"],
        ]
        excelView.reloadData()
    }
}
//MARK: - JmoVxia---override
extension CLExcelController {
}
//MARK: - JmoVxia---objc
@objc private extension CLExcelController {
}
//MARK: - JmoVxia---私有方法
private extension CLExcelController {
}
//MARK: - JmoVxia---公共方法
extension CLExcelController {
}
