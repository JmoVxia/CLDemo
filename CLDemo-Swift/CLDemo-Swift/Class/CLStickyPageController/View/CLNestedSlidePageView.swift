import CLStickyPage
import SnapKit
import UIKit

final class CLStickyPagePageView: UIView, CLStickyViewPage {
    private let rowPrefix: String
    private let rowCount: Int
    private let cellTint: UIColor

    private let tableView = UITableView()

    var scrollView: UIScrollView {
        tableView
    }

    init(
        frame: CGRect = .zero,
        rowPrefix: String = "Row",
        rowCount: Int = 50,
        cellTint: UIColor = UIColor.white.withAlphaComponent(0.72)
    ) {
        self.rowPrefix = rowPrefix
        self.rowCount = rowCount
        self.cellTint = cellTint
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    override init(frame: CGRect) {
        rowPrefix = "Row"
        rowCount = 50
        cellTint = UIColor.white.withAlphaComponent(0.72)
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CLStickyPagePageView {
    func setupUI() {
        tableView.bounces = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.contentInsetAdjustmentBehavior = .never
        addSubview(tableView)
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CLStickyPagePageView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(rowPrefix) \(indexPath.row + 1)"
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = cellTint
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
