//
//  profileAppearance.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/19.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

struct profileAppearance {
    static let photoLength:CGFloat = screenHeight < 600 ? 39 : 42
    static let padding:CGFloat = 6
    var name: String
    var userId: String
    var img: UIImage?
    var userConverseKeyID: String {
        get {
            return "converse_\(userId)"
        }
    }
    
    init(name: String, img: UIImage?, userId: String) {
        self.name = name
        self.userId = userId
        self.img = img ?? UIImage()
    }
    
    func addProfile(to view: UIView) {
        
        
    }
    
}
