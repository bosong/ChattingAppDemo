//
//  DateHeaderView.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/22.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

class DateHeaderView: UICollectionReusableView {
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 9, width: 80, height: 26))
        titleLabel.textAlignment = .center
        titleLabel.center = CGPoint(x: screenWidth/2, y: 20)
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        titleLabel.textColor = UIColor(white: 1, alpha: 1)
        titleLabel.backgroundColor = UIColor(white: 0.4, alpha: 0.5)
        self.addSubview(titleLabel)
    }
    
    
    func resetTitleFrame() {
        titleLabel.sizeToFit()
        titleLabel.frame.size = CGSize(width: titleLabel.frame.width + 16, height: 26)
        titleLabel.center = CGPoint(x: screenWidth/2, y: 20)
        titleLabel.layer.cornerRadius = 12
        titleLabel.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
