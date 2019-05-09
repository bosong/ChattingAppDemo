//
//  OverviewPicturesViewController.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/12/5.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

class OverviewPicturesViewController: UIViewController {
    
    @IBOutlet weak var collectionViewHolder: UIView!
    @IBOutlet weak var topBar: UIView!
//    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var backView: UIView!
    
    private var swipeInteractor:SwipeInteractionController?
    private var collectionVC = PictureDetailViewController()
    private var selectedImg: UIImage?
    
    weak var delegate: BubbleCollectionViewDelegate?
    var photoReturningCompletion: (() -> (Void))?
    var initialPhotoFrame = CGRect.zero
    var destinationFrame = CGRect.zero
    private var previousLocation: CGFloat = 0
    private var initialLocation: CGFloat = 0
    var delta:CGFloat = 0
    var initialCollectionViewY:CGFloat = 0
    var dismissWithAnimation: Bool {
        get {
            return converseDict[collectionVC.currentImgID] != nil
        }
    }
    var converseDict:[String:CGRect] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeInteractor = SwipeInteractionController(viewController: self)
        collectionVC.delegate = self.delegate
        self.utils.addChildViewController(collectionVC, onView: collectionViewHolder)
        self.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
       initialCollectionViewY = collectionViewHolder.frame.origin.y

        self.transitioningDelegate = self
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    func configUI(with profile: profileAppearance, converseList: [ConverseModel], selectedImage: String) {
        let imgs = ConverseModel.getImgList(from: converseList)
        collectionVC.imgList = imgs
        let index = imgs.firstIndex(where: { (info) -> Bool in
            if info.id == selectedImage {
                selectedImg = info.image
                return true
            }
            return false
        }) ?? 0
        collectionVC.selectedImgIndex = index
    }

    @IBAction func close(_ sender: UIButton) {
        dismiss()
    }
    
    func dismissPartialView(alpha: CGFloat) {
        backView.alpha = alpha
        topBar.alpha = alpha
//        bottomBar.alpha = alpha
    }
    
    @objc func dismiss() {
        dismissPartialView(alpha: 0)
        self.presentingViewController?.dismiss(animated: true, completion: {
            self.collectionViewHolder.frame.origin.y = self.initialCollectionViewY
            self.dismissPartialView(alpha: 1)
        })
    }
    func getImg() -> UIImage {
        return selectedImg ?? UIImage()
    }
}


extension OverviewPicturesViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let pc = VeilPresentationController(presentedViewController: presented, presenting: presenting)

        return pc
    }

    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let img = selectedImg ?? UIImage()
        let rect = rectForPresent(img: img)
        let vc = PanPresentAnimationController(startFrame: destinationFrame, interactionController: swipeInteractor, photoFrame: rect, img: img)
        return vc
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let d = converseDict[collectionVC.currentImgID] {
            self.destinationFrame = d
        }
        
        let rect = rectForDismissal(img: collectionVC.currentImg)
        let vc = PanDismissAnimationController(destinationFrame: destinationFrame, interactionController: swipeInteractor, photoFrame: rect, photoReturningCompletion: self.photoReturningCompletion ?? {})
      
        return vc
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? PanDismissAnimationController,
            let interactionController = animator.interactionController,
            interactionController.interactionInProgress
            else {
                return nil
        }
        return interactionController
    }
    
    func rectForDismissal(img: UIImage) -> CGRect {
        let holderFrame = self.collectionViewHolder.frame
        
        let w = holderFrame.width/initialPhotoFrame.width
        let h = holderFrame.height/initialPhotoFrame.height
        let scale = min(w, h)
        var f = initialPhotoFrame
        f.size = CGSize(width: scale * f.width, height: scale * f.height)
        let c = collectionViewHolder.frame.size
        f.origin = CGPoint(x: (c.width - f.size.width)/2, y: (c.height - f.size.height)/2)
        return f
    }
    
    func rectForPresent(img: UIImage) -> CGRect {
        let holderHeight = screenHeight - safeArea.bottom - safeArea.top
        
        let w = screenWidth/initialPhotoFrame.width
        let h = holderHeight/initialPhotoFrame.height
        let scale = min(w, h)
        var f = initialPhotoFrame
        f.size = CGSize(width: scale * f.width, height: scale * f.height)
        let sh = screenHeight - view.safeAreaInsets.top - view.safeAreaInsets.bottom
        f.origin = CGPoint(x: (screenWidth - f.size.width)/2, y: (sh - f.size.height)/2)
        return f
    }
}

extension OverviewPicturesViewController {
    
    func stepBack() {
        dismissPartialView(alpha: 1)
        delta = 0
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.collectionViewHolder.frame.origin.y = self.initialCollectionViewY
        }, completion: nil)
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            previousLocation = gesture.location(in: self.view).y
            initialLocation = gesture.location(in: self.view).y
        case .ended:
            let currentLocation = gesture.location(in: self.view).y
            delta = currentLocation - initialLocation
            
            if (delta.absolute)/screenHeight > 1/5 {
                
                dismiss()
            } else {
                stepBack()
            }
        case .changed:
            let currentLocation = gesture.location(in: self.view).y
            let d = previousLocation - currentLocation
            delta = currentLocation - initialLocation
            previousLocation = currentLocation
            collectionViewHolder.layer.frame.origin.y = collectionViewHolder.layer.frame.origin.y - d
            
            let progress = 1 - min(delta.absolute/(screenHeight * 0.6),1) + 0.005
            dismissPartialView(alpha: progress)
            
        case .cancelled:
            stepBack()
        default:
            stepBack()
        }
    
    }
    
}
