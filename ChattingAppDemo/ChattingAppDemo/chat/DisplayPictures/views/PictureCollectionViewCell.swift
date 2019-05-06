//
//  PictureCollectionViewCell.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/12/5.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    private var lastLocationY: CGFloat = 0
    private var originalImgFrame: CGRect = CGRect.zero
    override func awakeFromNib() {
        super.awakeFromNib()
        originalImgFrame = imgView.frame

    }
    
    func maskRect() -> CGRect? {
        
        guard let size = imgView.image?.size else {
            return nil
        }
        
        let imgRate = size.height/size.width
        let cellSize = self.frame.size
        let cellRate = cellSize.height/cellSize.width
        var f = self.frame
        
        if imgRate > cellRate {
            let imgHeight = f.size.height
            let imgWidth = imgHeight / imgRate
            f.origin.x = (f.size.width - imgWidth)/2
            f.size = CGSize(width: imgWidth, height: imgHeight)
        
        } else {
            let imgWidth = f.size.width
            let imgHeight = imgWidth * imgRate
            f.origin.y = (f.size.height - imgHeight)/2
            f.size = CGSize(width: imgWidth, height: imgHeight)
        }
        
        return f
    }
    
    @objc func handleGesture(pan: UIPanGestureRecognizer) {
        
        var imgFrame = imgView.frame
        
        switch pan.state {
        case .began:
            originalImgFrame = self.imgView.frame
            lastLocationY = pan.location(in: self.contentView).y
        case .changed:
            let currentLocation = pan.location(in: self.contentView).y
            let deltaY = currentLocation - lastLocationY
            lastLocationY = currentLocation
            imgFrame.origin.y = imgFrame.origin.y + deltaY
            
        default:
            imgFrame = originalImgFrame
        }
        
        imgView.frame = imgFrame
    }
}
