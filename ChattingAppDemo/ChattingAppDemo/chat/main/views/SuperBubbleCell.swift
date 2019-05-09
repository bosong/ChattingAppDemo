//
//  SuperBubbleCell.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/19.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

class SuperBubbleCell: UICollectionViewCell {
    
    private var profileConrol: UIControl!
    private var ImgView: UIImageView!
    private var timeLabel: UILabel!
    private var readLabel: UILabel!
    private var loadingView: UIView?
    private let activityLoader = UIActivityIndicatorView(style: .white)
    private var bgColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    weak var delegate: BubbleCollectionViewDelegate?
    var profile: profileAppearance?
    
    private var showProfile = false {
        didSet {
            profileConrol.isHidden = !showProfile
            if showProfile {
                self.contentView.bringSubviewToFront(profileConrol)
            }
        }
    }
    
    var converse: ConverseMessage? {
        didSet {
            if let c = converse {
                markTime(c.time)
                source = c.source
            }
        }
    }
    
    private var source: ConverseMessage.Source = .user
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let padding = profileAppearance.padding
        let length = profileAppearance.photoLength

        let rect = CGRect(x: padding, y: 0, width: length, height: length)
        profileConrol = UIControl(frame: rect)
        profileConrol.backgroundColor = UIColor.clear
        ImgView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: rect.size))
        ImgView.layer.cornerRadius = profileAppearance.photoLength/2
        ImgView.layer.masksToBounds = true
        ImgView.contentMode = .scaleAspectFill
        profileConrol.addSubview(ImgView)
        profileConrol.isHidden = true
        
        timeLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: self.contentView.frame.maxY - 18), size: CGSize(width: 25, height: 18)))
        timeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        timeLabel.textColor = UIColor(white: 0.65, alpha: 0.9)
    
        readLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: self.contentView.frame.maxY - 18), size: CGSize(width: 25, height: 18)))
        readLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        readLabel.textColor = UIColor(white: 0.65, alpha: 0.9)
        readLabel.textAlignment = .right
        markAsRead(true)
        self.contentView.addSubview(profileConrol)
        self.addSubview(timeLabel)
        self.addSubview(readLabel)
        
//        profileConrol.addTarget(self, action: #selector(presentProfile), for: .touchUpInside)
    }
    
//    @objc func presentProfile() {
//        delegate?.profileOverview()
//    }
    
    func adjustTimeLabelFrame(offsetX: CGFloat , offsetY: CGFloat, padding: CGFloat) {
        let labelSize = CGSize(width: 40, height: 18)
        var x = offsetX
        let y = offsetY
        readLabel.isHidden = source == .partner
        if source == .partner {
            x += profileAppearance.photoLength + profileAppearance.padding * 2 + padding
            
        } else {
            x = screenWidth - safeAreaInset - x - padding * 2 - labelSize.width - 4
        }
        let rect = CGRect(x: x, y: y - 18, width: labelSize.width, height: labelSize.height)
        timeLabel.textAlignment = source == .partner ? .left : .right
        timeLabel.frame = rect
        readLabel.frame = rect
        readLabel.frame.origin.y = rect.origin.y - rect.size.height
        
    }
    
    
    func configProfile(source: ConverseMessage.Source ,info: profileAppearance?) {
        guard let profile = info else {
            return
        }

        showProfile = source == .partner
        ImgView.image = profile.img
        self.profile = info
    }
    
    func markTime(_ date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: date)
    }
    
    func markAsRead(_ read: Bool) {
        if self.converse?.source == .user {
            readLabel.text = read ? "Read" : ""
        }
    }
    
    func configUI(message: ConverseMessage ,profileInfo: profileAppearance? = nil) {
            
    }
    

    
    func loading(_ showLoader: Bool) {
        
        
    }
    
    
}
