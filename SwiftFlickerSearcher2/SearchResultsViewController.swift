//
//  SearchResultsViewController.swift
//  SwiftFlickerSearcher2
//
//  Created by suraj poudel on 3/06/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit


private let revealDetails = "revealDetails"

class SearchResultsViewController:UIViewController{
    
    @IBOutlet weak var collectionView:UICollectionView!
    var searchResults:FlickrSearchResults?
    var selectedCellRect:CGRect = CGRectZero
    
    private let flipPresentAnimationController = FlipPresentAnimationController()
    private let flipDismissAnimationController = FlipDismissAnimationController()
    
    
    var collectionViewCellFrame:CGRect{
        let cellFromSuperView = collectionView.convertRect(selectedCellRect, toView: collectionView.superview)
        return cellFromSuperView
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let resultsCount = searchResults!.flickrPhotos.count
        
        title = "\(searchResults!.searchString) (\(resultsCount))"
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == revealDetails{
            selectedCellRect = sender!.frame
            let destinationViewController = segue.destinationViewController as! PhotoDetailViewController
            destinationViewController.transitioningDelegate = self
            destinationViewController.descriptionText = (sender as! SearchResultsCollectionViewCell).flickrPhoto?.title
        }
    }
}

extension SearchResultsViewController:UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults?.flickrPhotos.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! SearchResultsCollectionViewCell
        if let flickrPhoto = searchResults?.flickrPhotos[indexPath.item]{
            cell.flickrPhoto = flickrPhoto
            cell.heartToggleHandler = {
                [weak self] in
                if let strongSelf = self{
                    strongSelf.collectionView.reloadItemsAtIndexPaths([indexPath])
                }
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                
                cell.flickrPhoto?.loadThumbnail(false, completion: { (image, error) in
                    if let image = image{
                       dispatch_sync(dispatch_get_main_queue(), {
                        
                        let leftCorners:UIRectCorner = [.TopLeft,.BottomLeft]
                        let rightCorners:UIRectCorner = [.TopRight,.BottomRight]
                        let newImage = image.imageByScalingAndCroppingForSize(image.size).imageWithRoundedCornersSize(20, corners: leftCorners).imageWithRoundedCornersSize(20, corners: rightCorners)
                        
                            cell.imageView.image = newImage
                       })
                    }
                })
            })
            
            
        }
        
        return cell
    }
}

extension SearchResultsViewController:UIViewControllerTransitioningDelegate{
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        flipPresentAnimationController.originFrame = collectionViewCellFrame
        return flipPresentAnimationController
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        flipDismissAnimationController.destinationFrame = collectionViewCellFrame
        return flipDismissAnimationController
    }
    
}













