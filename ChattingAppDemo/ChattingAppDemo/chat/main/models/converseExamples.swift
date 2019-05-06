//
//  converseExamples.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/12/6.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

struct Examples {
    static let converse1 = [
        ConverseMessage(source: .partner, text: "", image: UIImage(named: "baby"), time: Date(timeInterval: -200066, since: Date()), identifier: "000012", contentType: .image),
        ConverseMessage(source: .user, text: "Hi~", image: nil, time: Date(timeInterval: -200065, since: Date()), identifier: "000001", contentType: .text),
        ConverseMessage(source: .user, text: "How are u", image: nil, time: Date(timeInterval: -200049, since: Date()), identifier: "000002", contentType: .text),
        ConverseMessage(source: .partner, text: "Would you like to go out with me?", image: nil, time: Date(timeInterval: -100031, since: Date()), identifier: "000003", contentType: .text),
        ConverseMessage(source: .user, text: "Bye", image: nil, time: Date(timeInterval: -100026, since: Date()), identifier: "000004", contentType: .text),
        ConverseMessage(source: .partner, text: "Would you like some coffee?\nStarbox has buy-one-get-one today!", image: nil, time: Date(timeInterval: -100015, since: Date()), identifier: "000005", contentType: .text),
        ConverseMessage(source: .user, text: "I don't like coffee", image: nil, time: Date(timeInterval: -100002, since: Date()), identifier: "000006", contentType: .text),
        ConverseMessage(source: .partner, text: "That way, it responds to changing of the layout, but it makes sure to clean up any old borders.By the way, if you are not subclassing UIImageView, but rather are putting this logic inside the view controller, you would override viewWillLayoutSubviews instead of layoutSubviews of UIView. But the basic idea would be the same.That way, it responds to changing of the layout, but it makes sure to clean up any old borders.By the way, if you are not subclassing UIImageView, but rather are putting this logic inside the view controller, you would override viewWillLayoutSubviews instead of layoutSubviews of UIView. But the basic idea would be the same.That way, it responds to changing of the layout, but it makes sure to clean up any old borders.By the way, if you are not subclassing UIImageView, but rather are putting this logic inside the view controller, you would override viewWillLayoutSubviews instead of layoutSubviews of UIView. But the basic idea would be the same.That way, it responds to changing of the layout, but it makes sure to clean up any old borders.By the way, if you are not subclassing UIImageView, but rather are putting this logic inside the view controller, you would override viewWillLayoutSubviews instead of layoutSubviews of UIView. But the basic idea would be the same.That way, it responds to changing of the layout, but it makes sure to clean up any old borders.By the way", image: nil, time: Date(), identifier: "000007", contentType: .text),
        ConverseMessage(source: .user, text: "...", image: nil, time: Date(), identifier: "000008", contentType: .text),
        
        ConverseMessage(source: .partner, text: "", image: UIImage(named: "snowball"), time: Date(), identifier: "0000010", contentType: .image),
        ConverseMessage(source: .partner, text: "", image: UIImage(named: "snowBall2"), time: Date(), identifier: "0000011", contentType: .image),
        ConverseMessage(source: .user, text: "", image: UIImage(named: "jack"), time: Date(), identifier: "0000013", contentType: .image)
        
    ]
    static let converse2 = [ConverseMessage(source: .partner, text: "", image: UIImage(named: "baby"), time: Date(), identifier: "000010", contentType: .image),
                     ConverseMessage(source: .user, text: "", image: UIImage(named: "baby2"), time: Date(), identifier: "000011", contentType: .image),
                     ConverseMessage(source: .partner, text: "", image: UIImage(named: "baby3"), time: Date(), identifier: "000012", contentType: .image),
                     ConverseMessage(source: .user, text: "", image: UIImage(named: "baby4"), time: Date(), identifier: "000013", contentType: .image),
                     ConverseMessage(source: .partner, text: "", image: UIImage(named: "baby"), time: Date(), identifier: "000014", contentType: .image),
                     ConverseMessage(source: .user, text: "", image: UIImage(named: "baby2"), time: Date(), identifier: "000015", contentType: .image),
                     ConverseMessage(source: .partner, text: "", image: UIImage(named: "baby3"), time: Date(), identifier: "000016", contentType: .image),
                     ConverseMessage(source: .user, text: "", image: UIImage(named: "baby4"), time: Date(), identifier: "000017", contentType: .image)
    ]

}

struct Friend {
    
    var profile:profileAppearance
    var lastTextingTime:String
    var lastText: String
    
    
    static func examples() -> [Friend] {
        
        
        return [
            Friend(profile: profileAppearance(name: "Jack", img: UIImage(named: "jack"), userId: "17010_err"), lastTextingTime: "4:15 PM", lastText: "hi~"), Friend(profile: profileAppearance(name: "Erroll", img: UIImage(named: "baby3"), userId: "17010_err"), lastTextingTime: "3:30 PM", lastText:"bye~")]
        
    }
}

