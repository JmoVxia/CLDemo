//
//  UIImage+Extension.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

extension UIImage {
    func tintedImage(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let context = context {
            context.setBlendMode(.sourceAtop)
        }
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
}
///生成纯色图片
func imageWithColor(_ color:UIColor) -> UIImage {
    let rect = CGRect(x:0,y:0,width:1,height:1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

