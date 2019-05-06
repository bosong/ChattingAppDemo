//
//  SeeAllTextViewController.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/12/4.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

class SeeAllTextViewController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    var text = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.text = text
    }

}
