//
//  PanDismissController.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/12/7.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

class PanDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let destinationFrame: CGRect
    let interactionController: SwipeInteractionController?
    private let photoFrame: CGRect
    private let photoReturningCompletion: () -> (Void)
    init(destinationFrame: CGRect, interactionController: SwipeInteractionController?, photoFrame: CGRect, photoReturningCompletion: @escaping () -> (Void)) {

        self.destinationFrame = destinationFrame
        self.interactionController = interactionController
        self.photoFrame = photoFrame
        self.photoReturningCompletion = photoReturningCompletion

    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? OverviewPicturesViewController,
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = fromVC.collectionViewHolder.resizableSnapshotView(from: photoFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
            else {
                return
        }

        snapshot.layer.masksToBounds = true        
        let containerView = transitionContext.containerView
       
        let animationView = UIView()
        animationView.backgroundColor = UIColor.clear
        var safeTop:CGFloat = 0
        if let nav = toVC.view.subviews.last as? UINavigationBar {
            safeTop = nav.frame.origin.y + nav.frame.height
            let safeBottom = toVC.view.safeAreaInsets.bottom
            
            let visibleRect = CGRect(x: 0, y: safeTop, width: toVC.view.frame.width, height: screenHeight - 56 - safeTop - safeBottom)
            
            animationView.frame = visibleRect
            var f = photoFrame
            let top = safeTop - nav.frame.height
            f.origin.y = (screenHeight - top - safeBottom - f.height)/2 + fromVC.delta

            snapshot.frame = f
            
        }
        containerView.addSubview(animationView)
        animationView.addSubview(snapshot)
       
        animationView.clipsToBounds = true
        
        fromVC.collectionViewHolder.isHidden = true
        let duration = transitionDuration(using: transitionContext)
    
        if !fromVC.dismissWithAnimation {
            photoReturningCompletion()
        }
        
      
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {

            if !fromVC.dismissWithAnimation {
                snapshot.alpha = 0
            }
            var translatedFrame = self.destinationFrame
            translatedFrame.origin.y = translatedFrame.origin.y - safeTop
            snapshot.frame = translatedFrame
            snapshot.layer.cornerRadius = 8
            
        }, completion: { (fini) in
            
            fromVC.collectionViewHolder.isHidden = false
            animationView.removeFromSuperview()
            snapshot.removeFromSuperview()
            
            if !transitionContext.transitionWasCancelled {
                
                self.photoReturningCompletion()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        })
        
    }
}
