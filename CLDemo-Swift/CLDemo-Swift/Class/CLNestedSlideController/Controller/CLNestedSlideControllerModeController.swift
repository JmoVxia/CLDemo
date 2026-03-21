import CLPinnedPage
import SnapKit
import UIKit

final class CLNestedSlideControllerModeController: CLController {
    private lazy var controllerPagerView: CLPinnedControllerPageView = {
        let view = CLPinnedControllerPageView(isLazyLoading: true)
        view.dataSource = self
        view.delegate = self
        view.hoverPinnedTopInset = 40
        return view
    }()

    private lazy var headerView: UIView = {
        let container = UIView()
        container.backgroundColor = .systemTeal.withAlphaComponent(0.35)

        let titleLabel = UILabel()
        titleLabel.text = "CLPinnedPageView Controller"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.text = "子控制器生命周期托管示例，hoverPinnedTopInset = 40"
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

    private lazy var segmentedBar: CLNestedSlideSegmentedBar = {
        let bar = CLNestedSlideSegmentedBar()
        bar.setTitles(pageData.map(\.title))
        bar.onSelect = { [weak self] index in
            self?.controllerPagerView.scrollToPage(at: index, animated: true)
        }
        return bar
    }()

    private let pageData: [(title: String, color: UIColor)] = [
        ("推荐", .systemGreen),
        ("热点", .systemBlue),
        ("收藏", .systemOrange),
        ("设置", .systemPurple),
    ]

    private var controllerCache: [Int: CLNestedSlideTablePageController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245 / 255, green: 247 / 255, blue: 251 / 255, alpha: 1)
        updateTitleLabel { label in
            label.text = "Controller 方案"
        }
        setupUI()
    }
}

private extension CLNestedSlideControllerModeController {
    func setupUI() {
        view.addSubview(controllerPagerView)
        controllerPagerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        headerView.snp.makeConstraints { make in
            make.height.equalTo(240)
        }

        segmentedBar.snp.makeConstraints { make in
            make.height.equalTo(60)
        }

        controllerPagerView.headerView = headerView
        controllerPagerView.hoverView = segmentedBar
        controllerPagerView.reload()
    }
}

extension CLNestedSlideControllerModeController: CLPinnedControllerPageViewDataSource {
    func numberOfPages(in controllerPageView: CLPinnedControllerPageView) -> Int {
        pageData.count
    }

    func controllerPageView(_ controllerPageView: CLPinnedControllerPageView, pageControllerAt index: Int) -> CLPinnedControllerPage {
        if let cached = controllerCache[index] {
            return cached
        }

        let data = pageData[index]
        let controller = CLNestedSlideTablePageController(title: data.title, accentColor: data.color)
        controllerCache[index] = controller
        return controller
    }

    func parentViewController(for controllerPageView: CLPinnedControllerPageView) -> UIViewController {
        self
    }
}

extension CLNestedSlideControllerModeController: CLPinnedControllerPageViewDelegate {
    func controllerPageView(_ controllerPageView: CLPinnedControllerPageView, contentScrollViewDidScroll scrollView: UIScrollView, progress: CGFloat) {
        let currentIndex = Int(progress.rounded())
        let clampedIndex = min(max(currentIndex, 0), pageData.count - 1)
        let offset = progress - CGFloat(clampedIndex)
        segmentedBar.updateIndicatorWithOffset(baseIndex: clampedIndex, offset: offset)
        segmentedBar.updateTitleColorWithProgress(baseIndex: clampedIndex, offset: offset)
    }

    func controllerPageView(_ controllerPageView: CLPinnedControllerPageView, didScrollToPageAt index: Int) {
        segmentedBar.setSelectedIndex(index)
    }
}
