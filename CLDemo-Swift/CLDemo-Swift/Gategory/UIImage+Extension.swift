//
//  UIImage+CLExtension.swift
//  CL
//
//  Created by JmoVxia on 2020/2/26.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension UIImage {
    ///生成纯色图片
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x:0,y:0,width:1,height:1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    ///修改图片颜色
    func tintImage(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, _: false, _: 0.0)
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
    ///修正方向图片
    var fixOrientationImage: UIImage {
        if imageOrientation == .up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

extension UIImage {
    // MARK: - 压缩图片大小
    func compressSize(with maxSize: Int) -> Data? {
        //先判断当前质量是否满足要求，不满足再进行压缩
        guard var finallImageData = jpegData(compressionQuality: 1.0) else {return nil}
        if finallImageData.count / 1024 <= maxSize {
            return finallImageData
        }
        //先调整分辨率
        var defaultSize = CGSize(width: 1024, height: 1024)
        guard let compressImage = scaleSize(defaultSize), let compressImageData = compressImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        finallImageData = compressImageData
        
        //保存压缩系数
        var compressionQualityArray = [CGFloat]()
        let avg: CGFloat = 1.0 / 250
        var value = avg
        var i: CGFloat = 250.0
        repeat {
            i -= 1
            value = i * avg
            compressionQualityArray.append(value)
        } while i >= 1
        
        //调整大小，压缩系数数组compressionQualityArr是从大到小存储，思路：使用二分法搜索
        guard let halfData = halfFuntion(array: compressionQualityArray, image: compressImage, sourceData: finallImageData, maxSize: maxSize) else {
            return nil
        }
        finallImageData = halfData
        //如果还是未能压缩到指定大小，则进行降分辨率
        while finallImageData.count == 0 {
            //每次降100分辨率
            if defaultSize.width - 100 <= 0 || defaultSize.height - 100 <= 0 {
                break
            }
            defaultSize = CGSize(width: defaultSize.width - 100, height: defaultSize.height - 100)
            guard let lastValue = compressionQualityArray.last,
                let newImageData = compressImage.jpegData(compressionQuality: lastValue),
                let tempImage = UIImage(data: newImageData),
                let tempCompressImage = tempImage.scaleSize(defaultSize),
                let sourceData = tempCompressImage.jpegData(compressionQuality: 1.0),
                let halfData = halfFuntion(array: compressionQualityArray, image: tempCompressImage, sourceData: sourceData, maxSize: maxSize) else {
                return nil
            }
            finallImageData = halfData
        }
        return finallImageData
    }

    // MARK: - 调整图片分辨率/尺寸（等比例缩放）
    func scaleSize(_ newSize: CGSize) -> UIImage? {
        let heightScale = size.height / newSize.height
        let widthScale = size.width / newSize.width
        
        var finallSize = CGSize(width: size.width, height: size.height)
        if widthScale > 1.0 && widthScale > heightScale {
            finallSize = CGSize(width: size.width / widthScale, height: size.height / widthScale)
        } else if heightScale > 1.0 && widthScale < heightScale {
            finallSize = CGSize(width: size.width / heightScale, height: size.height / heightScale)
        }
        UIGraphicsBeginImageContext(CGSize(width: Int(finallSize.width), height: Int(finallSize.height)))
        draw(in: CGRect(x: 0, y: 0, width: finallSize.width, height: finallSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    // MARK: - 二分法
    private func halfFuntion(array: [CGFloat], image: UIImage, sourceData: Data, maxSize: Int) -> Data? {
        var tempFinallImageData = sourceData
        var finallImageData = Data()
        var start = 0
        var end = array.count - 1
        var index = 0
        
        var difference = Int.max
        while start <= end {
            index = start + (end - start) / 2
            guard let data = image.jpegData(compressionQuality: array[index]) else {
                return nil
            }
            tempFinallImageData = data
            let sizeOrigin = tempFinallImageData.count
            let sizeOriginKB = sizeOrigin / 1024
            if sizeOriginKB > maxSize {
                start = index + 1
            } else if sizeOriginKB < maxSize {
                if maxSize - sizeOriginKB < difference {
                    difference = maxSize - sizeOriginKB
                    finallImageData = tempFinallImageData
                }
                if index<=0 {
                    break
                }
                end = index - 1
            } else {
                break
            }
        }
        return finallImageData
    }
}
extension UIImage {
    ///智能压缩图片大小
    func smartCompressImage() -> Data? {
        guard let finallImageData = jpegData(compressionQuality: 1.0) else {return nil}
        if finallImageData.count / 1024 <= 300 {
            return finallImageData
        }
        var width = size.width
        var height = size.height
        let longSide = max(width, height)
        let shortSide = min(width, height)
        let scale = shortSide / longSide
        if shortSide < 1080 || longSide < 1080 {
            return jpegData(compressionQuality: 0.5)
        }else {
            if width < height {
                width = 1080
                height = 1080 / scale
            }else {
                width = 1080 / scale
                height = 1080
            }
            UIGraphicsBeginImageContext(CGSize(width: width, height: height))
            draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            let compressImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return compressImage?.jpegData(compressionQuality: 0.5)
        }
    }
}
