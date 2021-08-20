//
//  HexagonalItemView.swift
//  Hexacon
//
//  Created by Gautier Gdx on 13/02/16.
//  Copyright © 2016 Gautier. All rights reserved.
//

import UIKit

protocol HexagonalItemViewDelegate: AnyObject {
    func hexagonalItemViewClikedOnButton(forIndex index: Int)
}

public class HexagonalItemView: UIImageView {
    
    // MARK: - data
    
    public init(image: UIImage, appearance: HexagonalItemViewAppearance) {
        if appearance.needToConfigureItem {
            let modifiedImage = image.roundImage(color: appearance.itemBorderColor, borderWidth: appearance.itemBorderWidth)
            super.init(image: modifiedImage)
        } else {
            super.init(image: image)
        }
    }
    
    public init(view: UIView) {
        let image = view.roundImage()
        super.init(image: image)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var index: Int?
    
    weak var delegate: HexagonalItemViewDelegate?
    
    // MARK: - event methods
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let index = index else { return }
        
        delegate?.hexagonalItemViewClikedOnButton(forIndex: index)
    }

}

internal extension UIView {
    
    func roundImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!.roundImage()
    }

}

internal extension UIImage {
    
    func roundImage(color: UIColor? = nil, borderWidth: CGFloat = 0) -> UIImage {
        guard self.size != .zero else { return self }
        
        let newImage = self.copy() as! UIImage
        let cornerRadius = self.size.height/2
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
        let bounds = CGRect(origin: CGPoint.zero, size: self.size)
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2), cornerRadius: cornerRadius)
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        // Clip the drawing area to the path
        path.addClip()
        
        // Draw the image into the context
        newImage.draw(in: bounds)
        context!.restoreGState()
        
        // Configure the stroke
        color?.setStroke()
        path.lineWidth = borderWidth
        
        // Stroke the border
        path.stroke()
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage ?? UIImage()
    }

}


