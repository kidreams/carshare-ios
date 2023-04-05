//
//  UIImage - marker.swift
//  CarShare
//
//  Created by nicholas on 3/28/23.
//

import UIKit

extension UIImage {
    func resize(to targetSize: CGSize) -> UIImage {
        let originalImage = self
        if CGSizeEqualToSize(originalImage.size, targetSize) {
            return originalImage
        }
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.main.scale)
        
        originalImage.draw(in: CGRect(origin: CGPoint.zero,
                                      size: CGSize(width: targetSize.width,
                                                   height: targetSize.height)))
        var newImage = originalImage
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            newImage = image
        }
        UIGraphicsEndImageContext()
        return newImage
    }
    
    var mapMarker: UIImage {
        self.resize(to: CGSize(width: 50, height: 50))
    }
}
