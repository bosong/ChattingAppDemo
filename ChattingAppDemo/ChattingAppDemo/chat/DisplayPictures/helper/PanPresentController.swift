//
//  PanPresentController.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/12/11.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

class PanPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let startFrame: CGRect
    let interactionController: SwipeInteractionController?
    private var photoFrame: CGRect
    private let photo: UIImage
    init(startFrame: CGRect,interactionController: SwipeInteractionController?, photoFrame: CGRect, img: UIImage) {
        
        self.startFrame = startFrame
        
        self.interactionController = interactionController
        
        self.photoFrame = photoFrame
        self.photo = img
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) as? OverviewPicturesViewController
            else {
                return
        }
       
        toVC.view.alpha = 1
        
        let photoSnapshot = UIImageView(image: photo)
        photoSnapshot.contentMode = .scaleAspectFit
        var f = photoFrame
        f.origin.y = (UIScreen.main.bounds.height - f.height)/2
        photoFrame = f
        
        // Construct Views
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(toVC.view, at: 0)
    
        
        let animationView = UIView(frame: containerView.frame)
        animationView.backgroundColor = UIColor(white: 0, alpha: 0.01)
        animationView.clipsToBounds = true
    
        
        animationView.addSubview(photoSnapshot)
        containerView.addSubview(animationView)
        
        // initialize Views
        photoSnapshot.layer.cornerRadius = 8
        photoSnapshot.layer.masksToBounds = true
        photoSnapshot.frame = startFrame
        toVC.view.isHidden = true
        let duration = transitionDuration(using: transitionContext)

        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            fromVC.view.alpha = 0

            var f = self.photoFrame
            f.origin.y = f.origin.y + 5
            photoSnapshot.frame = f
            photoSnapshot.layer.cornerRadius = 0
            animationView.backgroundColor = UIColor.black
            
        }, completion: { (fini) in
            fromVC.view.alpha = 1
            animationView.removeFromSuperview()
            toVC.view.isHidden = false
        
            if transitionContext.transitionWasCancelled {
                toVC.view.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}
