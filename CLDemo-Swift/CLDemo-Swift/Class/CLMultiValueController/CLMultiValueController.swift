//
//  CLMultiValueController.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2023/3/24.
//

import UIKit
import SwiftyJSON

class CLMultiValueController: CLController {
    lazy var button: UIButton = {
        let view = UIButton()
        view.setTitle("点我", for: .normal)
        view.setTitleColor(.red, for: .normal)
        view.backgroundColor = .orange
        view.addTarget(self, action: #selector(clickAction ), for: .touchUpInside)
        return view
    }()
    
    lazy var model: [CLMultiModel] = {
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        if let data = try? Data(contentsOf: url) {
            return JSON(data).arrayValue.compactMap({ .init(json: $0) })
        }
        return []
    }()
}
extension CLMultiValueController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

@objc extension CLMultiValueController {
    func clickAction() {
        
        let controller = CLMultiController()
        controller.dataSource = self
        present(controller, animated: false)
    }
}
extension CLMultiValueController: CLMultiDataSource {
    func multiController(_ controller: CLMultiController, tableView: UITableView, cellForRowAt indexPath: CLMultiIndexPath) -> UITableViewCell {
        var data: CLMultiModel?
        if indexPath.column == .zero {
            data = model[safe: indexPath.indexPath.row]
        }else {
            for selectedIndexPath in controller.selectedIndexPath {
                if let value = data {
                    data = value.children[safe: selectedIndexPath.indexPath.row]
                }else {
                    data = model[safe: selectedIndexPath.indexPath.row]
                }
            }
            data = data?.children[safe: indexPath.indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath.indexPath)
        cell.backgroundColor = .random
        cell.textLabel?.text = data?.name ?? "unknown"
        return cell
    }
    
    func multiController(_ controller: CLMultiController, didSelectRowAt indexPath: CLMultiIndexPath) -> String {
        var data: CLMultiModel?
        if indexPath.column == .zero {
            data = model[safe: indexPath.indexPath.row]
        }else {
            for selectedIndexPath in controller.selectedIndexPath {
                if let value = data {
                    data = value.children[safe: selectedIndexPath.indexPath.row]
                }else {
                    data = model[safe: selectedIndexPath.indexPath.row]
                }
            }
            data = data?.children[safe: indexPath.indexPath.row]
        }
        return data?.name ?? "请选择"
    }
    func multiController(_ controller: CLMultiController, isCompletedAt indexPath: CLMultiIndexPath) -> Bool {
        var data: CLMultiModel?
        if indexPath.column == .zero {
            data = model[safe: indexPath.indexPath.row]
        }else {
            for selectedIndexPath in controller.selectedIndexPath {
                if let value = data {
                    data = value.children[safe: selectedIndexPath.indexPath.row]
                }else {
                    data = model[safe: selectedIndexPath.indexPath.row]
                }
            }
            data = data?.children[safe: indexPath.indexPath.row]
        }
        return (data?.children.count ?? .zero) > 0
    }
    func multiController(_ controller: CLMultiController, numberOfItemsInColumn column: Int) -> Int {
        if column == .zero {
            return model.count
        }else {
            var data: CLMultiModel?
            for selectedIndexPath in controller.selectedIndexPath {
                if let value = data {
                    data = value.children[safe: selectedIndexPath.indexPath.row]
                }else {
                    data = model[safe: selectedIndexPath.indexPath.row]
                }
            }
            return data?.children.count ?? .zero
        }
    }
}
