//
//  SearchResultsCollectionViewCell.swift
//  SwiftFlickerSearcher2
//
//  Created by suraj poudel on 3/06/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

class SearchResultsCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet weak var heartButton:UIButton!
    @IBOutlet weak var imageView:UIImageView!
    
    typealias HeartToggleHandler = ()->()
    var heartToggleHandler:HeartToggleHandler? = nil
    
    var flickrPhoto:Photo?{
        didSet{
            if let flickrPhoto = self.flickrPhoto{
                if flickrPhoto.isFavorite{
                    self.heartButton.tintColor = UIColor(red:1, green:0, blue:0.517, alpha:1)
                }else{
                    self.heartButton.tintColor = UIColor.whiteColor()
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.imageView.setNeedsDisplay()
        self.setNeedsDisplay()
    }
    
    @IBAction func heartTapped(sender:AnyObject!){
        flickrPhoto!.isFavorite = !flickrPhoto!.isFavorite
        if let heartToggleHandler = heartToggleHandler{
            heartToggleHandler()
        }
    }
    
}