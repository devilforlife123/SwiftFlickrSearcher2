//
//  ImageCache.swift
//  SwiftFlickerSearcher2
//
//  Created by suraj poudel on 3/06/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

class ImageCache{
    
    var imageCache:[String:UIImage] = [:]
    
    class var sharedCache:ImageCache{
        struct Static{
            static var onceToken:dispatch_once_t = 0
            static var instance:ImageCache? = nil
        }
        
        dispatch_once(&Static.onceToken) { 
            Static.instance = ImageCache()
        }
        return Static.instance!
    }
    
    func imageForKey(photoID:String)->UIImage?{
        return imageCache[photoID]
    }
    
    func setImage(image:UIImage,forKey photoID:String){
        imageCache[photoID] = image 
    }
}
