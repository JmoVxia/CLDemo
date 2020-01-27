//
//  CLChatPhotoView.swift
//  Potato
//
//  Created by AUG on 2019/11/23.
//

import UIKit
import SnapKit

class CLChatPhotoView: UIView {
    ///间隙
    private var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: -20, right: -20)
    ///行间隙
    private var rowMargin: CGFloat = 20
    ///列间隙
    private var columnMargin: CGFloat = 20
    ///多少行
    private var rowNumber: Int = 2
    ///多少列
    private var columnNumber: Int = 4
    ///大小
    private var itemSize: CGSize {
        return CGSize(width: 80, height: 80)
    }
    ///控件宽度
    private var width: CGFloat {
        return cl_screenWidth()
    }
    ///控件高度
    private (set) var height: CGFloat {
        set {
            
        }
        get {
            return edgeInsets.top - edgeInsets.bottom + CGFloat(rowNumber - 1) * rowMargin + itemSize.height * CGFloat(rowNumber)
        }
    }
    ///相册按钮
    private lazy var albumButton: CLChatPhotoCellBotton = {
        let albumButton = CLChatPhotoCellBotton()
        albumButton.icon = UIImage.init(named: "btn_photo")
        albumButton.text = "相册"
        albumButton.addTarget(self, action: #selector(albumButtonAction), for: .touchUpInside)
        return albumButton
    }()
    ///相机按钮
    private lazy var cameraButton: CLChatPhotoCellBotton = {
        let cameraButton = CLChatPhotoCellBotton()
        cameraButton.icon = UIImage.init(named: "btn_potaograph")
        cameraButton.text = "相机"
        cameraButton.addTarget(self, action: #selector(cameraButtonButtonAction), for: .touchUpInside)
        return cameraButton
    }()
    ///点击相册
    var albumButtonCallback: (()->())?
    ///点击相机
    var cameraButtonCallback: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatPhotoView {
    private func initUI() {
        addSubview(albumButton)
        addSubview(cameraButton)
    }
    private func makeConstraints() {
        albumButton.snp.makeConstraints { (make) in
            make.left.equalTo(edgeInsets.left)
            make.top.equalTo(edgeInsets.top)
            make.size.equalTo(itemSize)
        }
        cameraButton.snp.makeConstraints { (make) in
            make.left.equalTo(albumButton.snp.right).offset(rowMargin)
            make.top.equalTo(edgeInsets.top)
            make.size.equalTo(itemSize)
        }
    }
}
extension CLChatPhotoView {
    ///控制器将要旋转
    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
        }) { (_) in
            
        }
    }
}
extension CLChatPhotoView {
    @objc private func albumButtonAction() {
        albumButtonCallback?()
    }
    @objc private func cameraButtonButtonAction() {
        cameraButtonCallback?()
    }
}
