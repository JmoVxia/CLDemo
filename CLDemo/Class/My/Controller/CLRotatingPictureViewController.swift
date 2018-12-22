//
//  CLRotatingPictureViewController.swift
//  CLDemo
//
//  Created by JmoVxia on 2018/12/22.
//  Copyright © 2018 JmoVxia. All rights reserved.
//

import UIKit
import Then

class CLRotatingPictureViewController: CLBaseViewController {
    
    var imageView: UIImageView!
    
    var image: UIImage!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        image = UIImage.init(named: "4")
        imageView = UIImageView().then({ (imageView) in
            view.addSubview(imageView)
            imageView.image = image
        })
        view.addSubview(imageView)
    }
    
    func calculationFrame(image: UIImage) -> CGRect {
        var x: CGFloat = 0
        var y: CGFloat = 0
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        var screenWidth: CGFloat
        var screenHeight: CGFloat

        if #available(iOS 11.0, *) {
            screenWidth = UIScreen.main.bounds.size.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right
        } else {
            screenWidth = UIScreen.main.bounds.size.width
        }
        if #available(iOS 11.0, *) {
            screenHeight = UIScreen.main.bounds.size.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        } else {
            screenHeight = UIScreen.main.bounds.size.width
        }
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let widthSpace = fabsf(Float(screenWidth - imageWidth))
        let heightSpace = fabsf(Float(screenHeight - imageHeight))
        
        if widthSpace >= heightSpace {
            if screenWidth > imageWidth {
                width = imageWidth * (screenHeight / imageHeight)
                height = imageHeight * (screenHeight / imageHeight)
            }else {
                width = imageWidth / (imageWidth / screenWidth)
                height = imageHeight / (imageWidth / screenWidth)
            }
        }else {
            if screenHeight > imageHeight {
                width = imageWidth * (screenWidth / imageWidth)
                height = imageHeight * (screenWidth / imageWidth)
            }else {
                width = imageWidth / (imageHeight / screenHeight)
                height = imageHeight / (imageHeight / screenHeight)
            }
        }
        x = (self.view.frame.size.width - width) * 0.5
        y = (self.view.frame.size.height - height) * 0.5
        return CGRect.init(x: x, y: y, width: width, height: height)
    }
    
    override func viewLayoutMarginsDidChange() {
        imageView.frame = self.calculationFrame(image: image)
    }
    
}
