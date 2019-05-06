//
//  BubbleCollectionViewCell.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/9.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit
var screenWidth:CGFloat {
    get {
        return UIScreen.main.bounds.width
    }
}
var screenHeight:CGFloat {
    get {
        return UIScreen.main.bounds.height
    }
}


class BubbleCollectionViewCell: SuperBubbleCell {
    
    @IBOutlet weak var bgViewLeading: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewWidth: NSLayoutConstraint!
    @IBOutlet weak var seeAllControl: UIControl!
    @IBOutlet weak var seeAllControlBorder: UIView!
    @IBOutlet weak var loadingMask: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    let padding:CGFloat = 4
    var isHeightCalculated: Bool = false
    var attribute: UICollectionViewLayoutAttributes?
    var isMe: Bool = false {
        didSet {
            borderColor = isMe ? style.myColorSet.border : style.partnersColorSet.border
            bgColor = isMe ? style.myColorSet.background : style.partnersColorSet.background
            seeAllControl.backgroundColor = bgColor
            seeAllControlBorder.backgroundColor = borderColor
        }
    }
    
    var bgColor: UIColor?
    var borderColor: UIColor?
    var borderLayer: CAShapeLayer?
    
    private var style:TextBubbleStyle = TextBubbleStyle(cornerRadius: 6, borderWidth: 1, partnersColorSet: (background: UIColor.white, border: 0xBCBABC.utils.asRGB), myColorSet: (background: 0xD3E2F6.utils.asRGB, border: 0x7E9ED5.utils.asRGB))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false

    }

    override func configUI(message: ConverseMessage ,profileInfo: profileAppearance? = nil) {
        
        guard message.isLoading() == false else {
            self.loading(true)
            print("BubbleCell is Loading ...")
            return
        }
        self.loading(false)
        
        self.converse = message
        let source = message.source
        self.textView.text = message.text
        self.isMe = source == .user
        bgView.backgroundColor = bgColor
        configProfile(source: source, info: profileInfo)
    }
    
    
    
    
    private func triangleMask(for frame: CGRect) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let trianglePath = UIBezierPath()
        
        let tailLength:CGFloat = 12
        let cornerRadius:CGFloat = 9
        
        let rightBound = frame.maxX - tailLength
        
        let startPoint = CGPoint(x: rightBound - cornerRadius, y: frame.minY)
        let startCorner = CGPoint(x: rightBound, y: frame.minY + cornerRadius)
        let rightTail = CGPoint(x: frame.maxX, y: frame.minY)
        let rightTailCurve = CGPoint(x: rightBound, y: frame.minY + tailLength)
        let point3 = CGPoint(x: rightBound, y: frame.maxY - cornerRadius)
        let point4 = CGPoint(x: point3.x - cornerRadius, y: frame.maxY)
        
        let leftBound = frame.minX + tailLength
        let bottomLeft = CGPoint(x: leftBound + cornerRadius, y: frame.maxY)
        let bottomLeftCorner = CGPoint(x: leftBound, y: frame.maxY - cornerRadius)
        
        let leftTail = CGPoint(x: frame.minX, y: frame.minY)
        let leftTailCurve = CGPoint(x: leftBound, y: frame.minY + tailLength)
        let topLeft = CGPoint(x: leftBound, y: frame.minY + cornerRadius)
        let topLeftCorner = CGPoint(x: leftBound + cornerRadius, y: frame.minY)
        
        // draw right part
        if isMe {
        trianglePath .move(to: rightTail)
        trianglePath .addQuadCurve(to: rightTailCurve, controlPoint: CGPoint(x: frame.maxX - tailLength/2 - 6, y: frame.minY + tailLength/2 - 1))

        } else {
            trianglePath.move(to: startPoint)
            trianglePath.addQuadCurve(to: startCorner, controlPoint: CGPoint(x: rightBound, y: frame.minY))
        }
        trianglePath .addLine(to: point3)
        trianglePath.addQuadCurve(to: point4, controlPoint: CGPoint(x: frame.maxX - tailLength, y: frame.maxY))
        // draw bottom
        
        trianglePath.addLine(to: bottomLeft)
        trianglePath .addQuadCurve(to: bottomLeftCorner, controlPoint: CGPoint(x: leftBound , y: frame.maxY))
    
        // draw left
        if isMe {
        trianglePath.addLine(to: topLeft)
        trianglePath .addQuadCurve(to: topLeftCorner, controlPoint: CGPoint(x: leftBound , y: frame.minY))
        } else {
            trianglePath.addLine(to: leftTailCurve)
            trianglePath.addQuadCurve(to: leftTail, controlPoint: CGPoint(x: frame.minX + tailLength/2 + 6, y: frame.minY + tailLength/2 - 1))
        }
        trianglePath .close()
        
        shapeLayer.path = trianglePath.cgPath
        return shapeLayer
    }
    
    
    private func applyTriangleMask(view: UIView) {
        
        let rect = CGRect(origin: .zero, size: CGSize(width: textView.frame.width + 40 , height: (attribute?.frame.size.height)!))
        self.bgViewLeading.constant = isMe ? screenWidth - safeAreaInset - padding * 2 - rect.size.width : 50
        
        let mask = triangleMask(for: rect)
        view.layer.mask = mask
        
        let frameLayer = CAShapeLayer()
        frameLayer.path = mask.path
        frameLayer.lineWidth = 1
        
        frameLayer.fillColor = nil
        if let border = borderLayer {
            border.path = mask.path
            border.strokeColor = borderColor?.cgColor
        } else {
            view.layer.addSublayer(frameLayer)
            borderLayer = frameLayer
        }

    }
    
    func drawTail() {
        applyTriangleMask(view: bgView)
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.isHeightCalculated = false
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        if !isHeightCalculated {
            
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            
            let s = min(size.width,screenWidth - safeAreaInset - 8)
            newFrame.size.width = CGFloat(ceilf(Float(s)))
            let desiredHeight: CGFloat = self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            newFrame.size.height = desiredHeight
            layoutAttributes.frame = newFrame
            self.attribute = layoutAttributes
            
            self.sizeToFit()
//            contentView.sizeToFit()
            drawTail()
        }
        
        seeAllControl.isHidden = bgView.frame.height < 800
        adjustTimeLabelFrame(offsetX: textView.frame.size.width + 30, offsetY: bgView.frame.height, padding: padding)
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
    
    @IBAction func seeAllText(_ sender: UIControl) {
        
        delegate?.seeAllText(str: converse?.text ?? "")
        
    }
    
    
    
}
