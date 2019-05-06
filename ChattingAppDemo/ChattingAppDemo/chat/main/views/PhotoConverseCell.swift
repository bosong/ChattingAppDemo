//
//  PhotoConverseCell.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/19.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit
let profileWidth:CGFloat = profileAppearance.photoLength
var safeAreaInset:CGFloat = 0
class PhotoConverseCell: SuperBubbleCell {

    @IBOutlet weak var loadingMask: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewLeading: NSLayoutConstraint!
    @IBOutlet weak var control: UIControl!
    @IBOutlet weak var shareControlCenterX: NSLayoutConstraint!
    @IBOutlet weak var shareControl: UIControl!
    
    private var imgSize = CGSize(width: 100, height: 100) {
        didSet {
            adjustTimeLabelFrame(offsetX: imgSize.width + padding, offsetY: imgSize.height, padding: 2)
        }
    }
    
    private var maxWidth:CGFloat {
        get {
            return min(screenWidth - 130, 240)
        }
    }
    private var maxHeight:CGFloat {
        get {
            return max(screenHeight/2 - 80, 250)
        }
    }
    private let minWidth:CGFloat = 100
    private let minHeight:CGFloat = 100
    private let minImgSize = CGSize(width: 100, height: 100)
    private let padding:CGFloat = 12
    var estimatedSize:CGSize = CGSize(width: 100, height: 100)
    var imgRect:CGRect {
        get {
            return self.control.convert(imgView.frame, to: self)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.contentMode = .scaleAspectFill
        shareControl.layer.cornerRadius = shareControl.frame.height/2
        shareControl.layer.masksToBounds = true
        estimatedSize = minImgSize
    }
    
    
    override func configUI(message: ConverseMessage, profileInfo: profileAppearance? = nil) {
        
        self.converse = message
        if let size = message.estimatedSize {
            self.estimatedSize = size
        }
        let source = converse?.source

        configProfile(source: message.source, info: profileInfo)
        adjustedImage(with: estimatedSize)
        if let img = message.image {
            imgView.image = img
            self.loading(false)
            
        } else {
            
            self.imgView.image = nil
            self.loading(true)
        }

        let w = imgSize.width
        imgViewWidth.constant = w
        imgViewLeading.constant = source == .user ? screenWidth - safeAreaInset - w - padding : padding + profileWidth + 8
        shareControlCenterX.constant = (w/2 + 20) * (source == .user ? -1 : 1)
        
        imgView.layer.cornerRadius = 8
        imgView.layer.masksToBounds = true
        control.layer.shadowColor = UIColor.lightGray.cgColor
        control.layer.shadowOpacity = 0.1
        control.layer.shadowRadius = 4
        
    }
    
    @IBAction func onControlTap(_ sender: UIControl) {
        if let p = profile {
            itsMyTurn(true)
            self.delegate?.viewPicture(profile: p, selectedImage: (self.converse?.identifier)!)
            
        }
    }
    
    func itsMyTurn(_ myTurn: Bool) {
        
        self.imgView.isHidden = myTurn
        
        if !myTurn {
            return
        }
        
        let f = self.frame
        var imgFrame = imgView.frame
        imgFrame.origin.y = f.origin.y + imgFrame.origin.y
        
        self.delegate?.getAllVisibleBubbles()
        self.delegate?.selectedCell(frame: imgFrame, XOffset: control.frame.origin.x + self.frame.origin.x)
        delegate?.setPhotoReturning {
            self.imgView.isHidden = false
        }
        
    }
    
    func adjustedImage(with size: CGSize) {
        
        let aspect = size.height/size.width
        let modelAspect = maxHeight/maxWidth
        var imgHeight: CGFloat = 0
        var imgWidth: CGFloat = 0
        
        if aspect > modelAspect {
        
            imgHeight = max(min(maxHeight, size.height), minHeight)
            imgWidth = imgHeight / aspect
        } else {
            
            imgWidth = max(min(maxWidth, size.width), minWidth)
            imgHeight = imgWidth * aspect
        }
        imgSize = CGSize(width: imgWidth, height: imgHeight)
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        layoutAttributes.frame.size.height = imgSize.height

        return layoutAttributes
    }

    override func loading(_ showLoader: Bool) {
        if showLoader {
            activityLoader.startAnimating()
            loadingMask.isHidden = false
        } else {
            activityLoader.stopAnimating()
            loadingMask.isHidden = true
        }
    }
}
