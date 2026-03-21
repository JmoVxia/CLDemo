import CLPinnedPage
import SnapKit
import UIKit

final class CLNestedSlideTablePageController: CLController, CLPinnedControllerPage {
    private let pageTitle: String
    private let accentColor: UIColor
    private let tableView = UITableView(frame: .zero, style: .plain)

    var scrollView: UIScrollView {
        tableView
    }

    init(title: String, accentColor: UIColor) {
        pageTitle = title
        self.accentColor = accentColor
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = accentColor.withAlphaComponent(0.08)
        setupTableView()
    }
}

private extension CLNestedSlideTablePageController {
    func setupTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CLNestedSlideRowCell.self, forCellReuseIdentifier: CLNestedSlideRowCell.reuseIdentifier)

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CLNestedSlideTablePageController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CLNestedSlideRowCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? CLNestedSlideRowCell else { return UITableViewCell() }
        cell.configure(text: "\(pageTitle) - 第 \(indexPath.row + 1) 行")
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}
