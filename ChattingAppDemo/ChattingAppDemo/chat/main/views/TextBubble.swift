//
//  TextBubble.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/9.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit




struct TextBubbleStyle {
    var cornerRadius: CGFloat = 0
    var borderWidth: CGFloat {
        didSet {
            if borderWidth > 2 {
                borderWidth = 2
            }
        }
    }
    var partnersColorSet: (background:UIColor, border:UIColor)
    var myColorSet: (background:UIColor, border:UIColor)
    
}

enum TextBubbleStyleOptions {
    case normal
    case custom
        
}
