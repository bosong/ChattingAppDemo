//
//  BubbleCollectionViewDelegate.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/19.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

protocol BubbleCollectionViewDelegate {
//    func profileOverview()
    func viewPicture(profile: profileAppearance, selectedImage: String)
    func resignKeyboard()
    func seeAllText(str: String)
    func selectedCell(frame: CGRect, XOffset: CGFloat)
    func setPhotoReturning(completion: @escaping () -> ())
    func getAllVisibleBubbles()
    func changePhoto(converseID: String)
}
