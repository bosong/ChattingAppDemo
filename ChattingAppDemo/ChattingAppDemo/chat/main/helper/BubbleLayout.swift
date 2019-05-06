//
//  BubbleLayout.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/12.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

class myFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
}
