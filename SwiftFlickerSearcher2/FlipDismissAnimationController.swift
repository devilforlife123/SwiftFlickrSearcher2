//
//  FlipDismissAnimationController.swift
//  SwiftFlickerSearcher2
//
//  Created by suraj poudel on 3/06/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

class FlipDismissAnimationController:NSObject,UIViewControllerAnimatedTransitioning{
    
    var destinationFrame = CGRectZero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey), let containerView = transitionContext.containerView(),let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)else {
            return
        }
        
        //get the final Frame
        let finalFrame = destinationFrame
        
        // Take the snapShot that is the initial Frame
        
        let snapShot = fromVC.view.snapshotViewAfterScreenUpdates(false)
        snapShot.layer.cornerRadius = 25
        snapShot.layer.masksToBounds = true
        
        
        //Add the snapShot and toVC in the container
        
        containerView.addSubview(snapShot)
        containerView.addSubview(toVC.view)
        fromVC.view.hidden = true
        
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        
        toVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateKeyframesWithDuration(duration, delay: 0, options: .CalculationModeCubic, animations: {
            //Decrease the size of the snapShot to finalFrame size
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/3, animations: {
                snapShot.frame = finalFrame
            })
            
            //Rotate the snapShot to positive 90
            UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
                snapShot.layer.transform = AnimationHelper.yRotation(M_PI_2)
            })
            
            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
            })
        }) { _ in
            fromVC.view.hidden = false
            snapShot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
    }
}
