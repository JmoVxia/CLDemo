//
//  CLMultiValueController.swift
//  CLDemo-Swift
//
//  Created by JmoVxia on 2023/3/24.
//

import SwiftyJSON
import UIKit

class CLMultiValueController: CLController {
    lazy var button: UIButton = {
        let view = UIButton()
        view.setTitle("点我", for: .normal)
        view.setTitleColor(.red, for: .normal)
        view.backgroundColor = .orange
        view.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        return view
    }()

    private var model: [CLMultiModel] = []

    private lazy var multiController: CLMultiController = {
        let controller = CLMultiController()
        controller.dataSource = self
        return controller
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
        present(multiController, animated: false)
        if model.isEmpty {
            DispatchQueue.global().async {
                self.model = {
                    let path = Bundle.main.path(forResource: "data", ofType: "json")
                    let url = URL(fileURLWithPath: path!)
                    if let data = try? Data(contentsOf: url) {
                        return JSON(data).arrayValue.compactMap { .init(json: $0) }
                    }
                    return []
                }()
                DispatchQueue.main.async {
                    self.multiController.reload()
                }
            }
        } else {
            multiController.reload()
        }
    }
}

extension CLMultiValueController: CLMultiDataSource {
    func multiController(_ controller: CLMultiController, tableView: UITableView, cellForRowAt indexPath: CLMultiIndexPath) -> UITableViewCell {
        let data = retrieveModel(at: indexPath)
        let cell: CLMultiCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CLMultiCell") as? CLMultiCell else { return CLMultiCell(style: .default, reuseIdentifier: "CLMultiCell") }
            return cell
        }()
        cell.titleButton.setTitle(data?.name ?? "", for: .normal)
        return cell
    }

    func multiController(_ controller: CLMultiController, didSelectRowAt indexPath: CLMultiIndexPath) -> String {
        let data = retrieveModel(at: indexPath)
        return data?.name ?? "请选择"
    }

    func multiController(_ controller: CLMultiController, isCompletedAt indexPath: CLMultiIndexPath) -> Bool {
        let data = retrieveModel(at: indexPath)
        return (data?.children.count ?? .zero) > 0
    }

    func multiController(_ controller: CLMultiController, numberOfItemsInColumn column: Int) -> Int {
        if column == .zero {
            return model.count
        } else {
            var data: CLMultiModel?
            for selectedIndexPath in controller.selectedIndexPath {
                if let value = data {
                    data = value.children[safe: selectedIndexPath.indexPath.row]
                } else {
                    data = model[safe: selectedIndexPath.indexPath.row]
                }
            }
            return data?.children.count ?? .zero
        }
    }
}

private extension CLMultiValueController {
    func retrieveModel(at indexPath: CLMultiIndexPath) -> CLMultiModel? {
        guard indexPath.column != .zero else { return model[safe: indexPath.indexPath.row] }

        var multiModel: CLMultiModel?
        for selectedIndexPath in multiController.selectedIndexPath
            where selectedIndexPath.column < indexPath.column
        {
            multiModel = (multiModel != nil) ? multiModel?.children[safe: selectedIndexPath.indexPath.row] : model[safe: selectedIndexPath.indexPath.row]
        }
        return multiModel?.children[safe: indexPath.indexPath.row]
    }
}
