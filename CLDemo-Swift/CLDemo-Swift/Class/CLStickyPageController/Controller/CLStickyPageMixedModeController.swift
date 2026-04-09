import CLStickyPage
import SnapKit
import UIKit

class CLStickyPageMixedModeController: CLController {
    enum PageKind {
        case view
        case controller
    }

    enum CompositionMode: Int, CaseIterable {
        case viewOnly
        case controllerOnly
        case mixed

        var segmentedTitle: String {
            switch self {
            case .viewOnly:
                "纯 View"
            case .controllerOnly:
                "纯 Controller"
            case .mixed:
                "混合"
            }
        }

        var subtitle: String {
            switch self {
            case .viewOnly:
                "CLStickyView 统一容器：全部返回 View 页面"
            case .controllerOnly:
                "CLStickyView 统一容器：全部返回 Controller 页面"
            case .mixed:
                "CLStickyView 统一容器：同一容器内混用 View + Controller"
            }
        }
    }

    struct PageConfig {
        let title: String
        let color: UIColor
        let kind: PageKind
    }

    private lazy var stickyView: CLStickyView = {
        let view = CLStickyView(isLazyLoading: true)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "CLStickyView（统一容器）"
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.88)
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var compositionControl: UISegmentedControl = {
        let control = UISegmentedControl(items: CompositionMode.allCases.map(\.segmentedTitle))
        control.selectedSegmentIndex = CompositionMode.mixed.rawValue
        control.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        control.selectedSegmentTintColor = UIColor.white.withAlphaComponent(0.95)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor(white: 0.3, alpha: 1),
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
        ], for: .selected)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
        ], for: .normal)
        control.addTarget(self, action: #selector(handleCompositionChanged), for: .valueChanged)
        return control
    }()

    private lazy var headerView: UIView = {
        let container = UIView()
        container.backgroundColor = .systemIndigo.withAlphaComponent(0.28)
        return container
    }()

    private let pageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 235 / 255, green: 243 / 255, blue: 252 / 255, alpha: 1)
        return view
    }()

    private lazy var segmentedBar: CLStickyPageSegmentedBar = {
        let bar = CLStickyPageSegmentedBar()
        bar.setTitles(pageData.map(\.title))
        bar.onSelect = { [weak self] index in
            self?.stickyView.scrollToPage(at: index, animated: true)
        }
        return bar
    }()

    private var compositionMode: CompositionMode = .mixed
    private var pageData: [PageConfig] = []

    private var viewCache: [Int: CLStickyPagePageView] = [:]
    private var controllerCache: [Int: CLStickyPageTablePageController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245 / 255, green: 247 / 255, blue: 251 / 255, alpha: 1)
        updateTitleLabel { label in
            label.text = "统一容器方案"
        }
        setupUI()
        applyCompositionMode(.mixed, keepCurrentPage: false)
    }
}

private extension CLStickyPageMixedModeController {
    func setupUI() {
        view.addSubview(stickyView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        headerView.addSubview(compositionControl)

        stickyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        headerView.snp.makeConstraints { make in
            make.height.equalTo(270)
        }

        segmentedBar.snp.makeConstraints { make in
            make.height.equalTo(60)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(48)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }

        compositionControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(14)
            make.height.equalTo(34)
        }

        stickyView.headerView = headerView
        stickyView.hoverView = segmentedBar
        stickyView.backgroundView = pageBackgroundView
    }

    func configs(for mode: CompositionMode) -> [PageConfig] {
        switch mode {
        case .viewOnly:
            [
                .init(title: "图文", color: .systemBlue, kind: .view),
                .init(title: "推荐", color: .systemGreen, kind: .view),
                .init(title: "动态", color: .systemOrange, kind: .view),
                .init(title: "收藏", color: .systemPurple, kind: .view),
            ]
        case .controllerOnly:
            [
                .init(title: "图文", color: .systemBlue, kind: .controller),
                .init(title: "推荐", color: .systemGreen, kind: .controller),
                .init(title: "动态", color: .systemOrange, kind: .controller),
                .init(title: "收藏", color: .systemPurple, kind: .controller),
            ]
        case .mixed:
            [
                .init(title: "图文", color: .systemBlue, kind: .view),
                .init(title: "推荐", color: .systemGreen, kind: .controller),
                .init(title: "动态", color: .systemOrange, kind: .view),
                .init(title: "收藏", color: .systemPurple, kind: .controller),
            ]
        }
    }

    func applyCompositionMode(_ mode: CompositionMode, keepCurrentPage: Bool) {
        let nextConfigs = configs(for: mode)
        let maxIndex = max(nextConfigs.count - 1, 0)
        let targetPage = keepCurrentPage ? min(stickyView.currentPageIndex, maxIndex) : 0
        compositionMode = mode
        subtitleLabel.text = mode.subtitle
        pageData = nextConfigs
        viewCache.removeAll()
        controllerCache.removeAll()

        segmentedBar.setTitles(pageData.map(\.title))
        segmentedBar.setSelectedIndex(targetPage, animated: false)
        stickyView.reload(toPageAt: targetPage)
    }

    @objc func handleCompositionChanged() {
        guard
            let mode = CompositionMode(rawValue: compositionControl.selectedSegmentIndex),
            mode != compositionMode
        else {
            return
        }
        applyCompositionMode(mode, keepCurrentPage: true)
    }
}

extension CLStickyPageMixedModeController: CLStickyViewDataSource {
    func numberOfPages(in stickyView: CLStickyView) -> Int {
        pageData.count
    }

    func stickyView(_ stickyView: CLStickyView, pageAt index: Int) -> CLStickyPage {
        let config = pageData[index]
        switch config.kind {
        case .view:
            if let cached = viewCache[index] {
                return cached
            }
            let view = CLStickyPagePageView(
                rowPrefix: "\(config.title) · 行",
                rowCount: 36,
                cellTint: config.color.withAlphaComponent(0.18)
            )
            view.backgroundColor = .clear
            viewCache[index] = view
            return view
        case .controller:
            if let cached = controllerCache[index] {
                return cached
            }
            let controller = CLStickyPageTablePageController(title: config.title, accentColor: config.color)
            controllerCache[index] = controller
            return controller
        }
    }

    func parentViewController(for stickyView: CLStickyView) -> UIViewController? {
        switch compositionMode {
        case .viewOnly:
            nil
        case .controllerOnly, .mixed:
            self
        }
    }
}

extension CLStickyPageMixedModeController: CLStickyViewDelegate {
    func stickyView(_ stickyView: CLStickyView, contentScrollViewDidScroll scrollView: UIScrollView, progress: CGFloat) {
        guard !pageData.isEmpty else { return }
        let currentIndex = Int(progress.rounded())
        let clampedIndex = min(max(currentIndex, 0), pageData.count - 1)
        let offset = progress - CGFloat(clampedIndex)
        segmentedBar.updateIndicatorWithOffset(baseIndex: clampedIndex, offset: offset)
        segmentedBar.updateTitleColorWithProgress(baseIndex: clampedIndex, offset: offset)
    }

    func stickyView(_ stickyView: CLStickyView, didScrollToPageAt index: Int) {
        segmentedBar.setSelectedIndex(index)
    }
}
