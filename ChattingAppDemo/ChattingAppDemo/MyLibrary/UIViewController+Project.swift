//
//  UIViewController+Project.swift
//  UCB-Banking
//
//  Created by erroll on 2018/6/29.
//  Copyright © 2018年 erroll. All rights reserved.
//

import UIKit

extension Project where Base: UIViewController {
    

    func setNavigationTitle(_ text: String?) {
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30, height: 30)))
        label.text = text
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        label.textColor = UIColor.darkGray
        base.navigationItem.titleView = label
    }
    
//    func setBackBarButton(title: String?) {
//        base.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
////        base.navigationItem.backBarButtonItem?.tintColor = UIColor.white //用這個在新的iOS才有效
//        base.navigationController?.navigationBar.tintColor = 0x4BC5C4.utils.asRGB
//    }
    
    func layoutAtFirst() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.base.view.layoutIfNeeded()
        }, completion: nil)

    }
    

    
}

/// Extend Type inherited from UIViewController with `Project` proxy.
extension UIViewController: ProjectCompatible { }
