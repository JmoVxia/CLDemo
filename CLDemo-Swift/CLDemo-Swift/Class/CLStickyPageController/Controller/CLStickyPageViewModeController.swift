import CLStickyPage
import SnapKit
import UIKit

class CLStickyPageViewModeController: CLController {
    private lazy var pagerView: CLStickyPageView = {
        let view = CLStickyPageView(isLazyLoading: false)
        view.dataSource = self
        view.delegate = self
        view.hoverStickyTopInset = 40
        return view
    }()

    private lazy var headerView: UIView = {
        let container = UIView()
        container.backgroundColor = .orange.withAlphaComponent(0.35)

        let titleLabel = UILabel()
        titleLabel.text = "CLStickyPageView View"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.text = "纯 View 页面示例，hoverStickyTopInset = 40"
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textAlignment = .center

        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(48)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        return container
    }()

    private let pageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .red.withAlphaComponent(0.3)
        return view
    }()

    private lazy var segmentedBar: CLStickyPageSegmentedBar = {
        let bar = CLStickyPageSegmentedBar()
        bar.backgroundColor = .clear
        bar.setTitles(pageData.map(\.title))
        bar.onSelect = { [weak self] index in
            self?.pagerView.scrollToPage(at: index, animated: true)
        }
        return bar
    }()

    private let pageData: [(title: String, color: UIColor)] = [
        ("首页", .systemGreen),
        ("发现", .systemBlue),
        ("我的", .systemOrange),
        ("设置", .systemPurple),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245 / 255, green: 247 / 255, blue: 251 / 255, alpha: 1)
        updateTitleLabel { label in
            label.text = "View 方案"
        }
        setupUI()
    }
}

private extension CLStickyPageViewModeController {
    func setupUI() {
        view.addSubview(pagerView)
        pagerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        headerView.snp.makeConstraints { make in
            make.height.equalTo(240)
        }

        segmentedBar.snp.makeConstraints { make in
            make.height.equalTo(60)
        }

        pagerView.headerView = headerView
        pagerView.hoverView = segmentedBar
        pagerView.backgroundView = pageBackgroundView
        pagerView.reload()
    }
}

extension CLStickyPageViewModeController: CLStickyPageViewDataSource {
    func numberOfPages(in pageView: CLStickyPageView) -> Int {
        pageData.count
    }

    func pageView(_ pageView: CLStickyPageView, pageAt index: Int) -> CLStickyViewPage {
        let view = CLStickyPagePageView()
        view.backgroundColor = .clear
        return view
    }
}

extension CLStickyPageViewModeController: CLStickyPageViewDelegate {
    func pageView(_ pageView: CLStickyPageView, contentScrollViewDidScroll scrollView: UIScrollView, progress: CGFloat) {
        let currentIndex = Int(progress.rounded())
        let clampedIndex = min(max(currentIndex, 0), pageData.count - 1)
        let offset = progress - CGFloat(clampedIndex)
        segmentedBar.updateIndicatorWithOffset(baseIndex: clampedIndex, offset: offset)
        segmentedBar.updateTitleColorWithProgress(baseIndex: clampedIndex, offset: offset)
    }

    func pageView(_ pageView: CLStickyPageView, didScrollToPageAt index: Int) {
        segmentedBar.setSelectedIndex(index)
    }
}
