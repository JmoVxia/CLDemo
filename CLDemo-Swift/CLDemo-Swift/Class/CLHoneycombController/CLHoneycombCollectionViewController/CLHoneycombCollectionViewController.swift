//
//  CLHoneycombCollectionViewController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/13.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---类-属性
class CLHoneycombCollectionViewController: CLController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    private lazy var collectionView: UICollectionView = {
        let layout = CLHoneycombLayout()
        layout.itemsPerRow = 4
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(CLHoneycombCollectionViewCell.self, forCellWithReuseIdentifier: "CLHoneycombCollectionViewCell")
        return view
    }()
}
//MARK: - JmoVxia---生命周期
extension CLHoneycombCollectionViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
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
private extension CLHoneycombCollectionViewController {
    func initUI() {
        updateTitleLabel { label in
            label.text = "UICollectionView"
        }
        view.backgroundColor = .hex("#93DAAE")
        view.addSubview(collectionView)
    }
    func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension CLHoneycombCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLHoneycombCollectionViewCell", for: indexPath)
        (cell as? CLHoneycombCollectionViewCell)?.imageView.image = UIImage(named: "Hexagon-\(indexPath.row % 30 + 1)")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 210
    }
}
extension CLHoneycombCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? CLHoneycombCollectionViewCell)?.animation()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("===== \(indexPath.row) =====")
    }
}
