//
//  PhotoDetailsViewController.swift
//  SwiftFlickerSearcher2
//
//  Created by suraj poudel on 3/06/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailViewController:UIViewController{
    
    @IBOutlet private weak var descriptionLabel:UILabel!
    @IBOutlet private weak var cardView:UIView!
    
    var descriptionText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let descriptionText = descriptionText{
            descriptionLabel.text = descriptionText
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PhotoDetailViewController.handleTap))
        cardView.addGestureRecognizer(tapRecognizer)
    }
    
    func handleTap(){
         dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismissPressed(sender:AnyObject){
        dismissViewControllerAnimated(true, completion: nil)
    }
}