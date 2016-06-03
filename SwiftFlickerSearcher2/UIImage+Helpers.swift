//
//  UIImage+Helpers.swift
//  SwiftFlickerSearcher2
//
//  Created by suraj poudel on 3/06/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func imageWithRoundedCornersSize(cornerRadius: CGFloat, corners: UIRectCorner) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        
        UIBezierPath(roundedRect: CGRectMake(00, 0, self.size.width, self.size.height), byRoundingCorners: corners, cornerRadii: CGSizeMake(cornerRadius, cornerRadius)).addClip()
        drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func imageByScalingAndCroppingForSize(targetSize: CGSize) -> UIImage {
        let sourceImage = self
        var newImage = UIImage()
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPointMake(0.0,0.0)
        
        if CGSizeEqualToSize(imageSize, targetSize) == false {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            
            if (widthFactor > heightFactor) {
                scaleFactor = widthFactor
            }
                
            else {
                scaleFactor = heightFactor
            }
            
            scaledWidth  = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            if (widthFactor > heightFactor) {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }
                
            else if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        
        var thumbnailRect = CGRectZero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width  = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.drawInRect(thumbnailRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
