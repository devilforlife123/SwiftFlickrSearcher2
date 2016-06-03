//
//  CarouselLayout.swift
//  SwiftFlickerSearcher2
//
//  Created by suraj poudel on 3/06/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

private let photoWidth:CGFloat = UIScreen.mainScreen().bounds.width*3/4
private let photoHeight:CGFloat = UIScreen.mainScreen().bounds.height*1/2

class CarouselLayout:UICollectionViewFlowLayout{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        itemSize = CGSizeMake(photoWidth, photoHeight)
        minimumInteritemSpacing = 10
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: collectionView!.bounds.width/2 - photoWidth/2, bottom: 0, right: collectionView!.bounds.width/2 - photoWidth/2)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = super.layoutAttributesForElementsInRect(rect)
        
        for attributes in array!{
            
            let frame = attributes.frame
            let distance = abs(collectionView!.contentOffset.x + collectionView!.contentInset.left - frame.origin.x)
            //if distance is 0 then the scale is 1
            //The distance is zero when the contentInset + contentoffset.x  == frame.origin.x
            let scale = min(max(0.7, 1-distance/self.collectionView!.bounds.width), 1.0)
            attributes.transform = CGAffineTransformMakeScale(scale, scale)
        }
        
        return array
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        //Proposed point where the collectionView should snap to
        var newOffset = CGPoint()
        
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let width = layout.itemSize.width + layout.minimumInteritemSpacing
        var offset = proposedContentOffset.x + collectionView!.contentInset.left
        if velocity.x > 0{
            offset = offset * ceil(offset/width)
        }
        
        if velocity.x == 0{
            offset = offset * round(offset/width)
        }
        
        if velocity.x < 0{
            offset = offset * floor(offset/width)
        }
        
        newOffset.x = offset - collectionView!.contentInset.left
        newOffset.y = proposedContentOffset.y
        
        return newOffset
    }
}
