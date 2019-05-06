//
//  ChatScrollViewController.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/9.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

let iPhoneX = (UIScreen.main.bounds.width >= 375 && UIScreen.main.bounds.height >= 812)
var safeArea: UIEdgeInsets = UIEdgeInsets.zero
var safeAreaWithNav: UIEdgeInsets = UIEdgeInsets.zero

class ChattingViewController: UIViewController {

    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toolViewWidth: NSLayoutConstraint!
    @IBOutlet weak var toolView: UIView!
        @IBOutlet weak var myToolBar: UIView!
    @IBOutlet weak var myToolBarBottom: NSLayoutConstraint!

    @IBOutlet weak var bubbleHolder: UIView!

    var profile: profileAppearance!
    var textViewMessageIsValid = false
    var bubbleVC = BubbleCollectionViewController()
    private var overviewVC = OverviewPicturesViewController()
    let imgPickerVC = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        bubbleVC.delegate = self
        bubbleVC.profileInfo = self.profile
        
        self.utils.addChildViewController(bubbleVC, onView: bubbleHolder)
        textBgView.layer.cornerRadius = textBgView.frame.height/3
        textBgView.layer.masksToBounds = true
        textBgView.layer.borderColor = UIColor.lightGray.cgColor
        textBgView.layer.borderWidth = 0.3
    
        textView.delegate = self
        
        self.project.setNavigationTitle("Chat Example")
      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        safeAreaWithNav = view.safeAreaInsets
        if let nh = self.navigationController?.navigationBar.frame.height {
            safeArea.top = safeAreaWithNav.top - nh
            safeArea.bottom = safeAreaWithNav.bottom
        }
    }
    
    @IBAction func uploadImage(_ sender: UIButton) {
        
        
//        imgPickerVC.sourceType = sender.tag == 0 ? .camera : .photoLibrary
        
        imgPickerVC.sourceType = .photoLibrary
        imgPickerVC.delegate = self
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        guard textViewMessageIsValid else {
            return
        }
        
        let message = textView.text
        let converse = ConverseMessage(source: .user, text: message ?? "", image: nil, time: Date(), identifier: "\(Date())", contentType: .text)
        bubbleVC.send(converse: converse)
        textView.text = ""
        textViewMessageIsValid = false
    }
    
}

extension ChattingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
//        showTool(false)
        textView.text = nil
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        textView.text = "Type Your Message..."
        textView.textColor = UIColor.lightGray
    }

    func textViewDidChange(_ textView: UITextView) {
        textViewMessageIsValid = textView.contentIsValid()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        adjustInsetForKeyboardShow(show: false, notification: notification)
    }

    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let adjustment = keyboardFrame.height - (iPhoneX ? 34 : 0)
        myToolBarBottom.constant = show ? -1 * adjustment : 0
        bubbleVC.updateCollectionViewlayout(adjustment: adjustment, showKeyBoard: show)
    }
}
extension ChattingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func lowQualityImage(_ image: UIImage) -> UIImage {
        let maxWidth:CGFloat = min(screenWidth - 130, 240)
        let maxHeight:CGFloat = max(screenHeight/2 - 80, 250)
        let size = CGSize(width: maxWidth, height: maxHeight)
        return image.utils.limited(by: size)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let coverImageKey = info[UIImagePickerController.InfoKey.originalImage]
        
        if let image = coverImageKey as? UIImage {
            let img = lowQualityImage(image)
            let converse = ConverseMessage(source: .user, text: "", image: img, time: Date(), identifier: "\(Date())", contentType: .image)
            bubbleVC.send(converse: converse)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChattingViewController: BubbleCollectionViewDelegate {
    func getAllVisibleBubbles() {
        var dict:[String:CGRect] = [:]
        let visibleCells = self.bubbleVC.collectionView.visibleCells
        _ = UIView(frame: UIScreen.main.bounds)
        for cell in visibleCells {
            if let c = cell as? PhotoConverseCell , let converse = c.converse{
                
//                print("convert rect: \(c.frame) to: \(c.convert(c.imgRect, to: self.view))")
                dict[converse.identifier] = c.convert(c.imgRect, to: self.view)
            }
        }
        
        overviewVC.converseDict = dict
    }
    
    func changePhoto(converseID: String) {
        bubbleVC.turnTo(converse: converseID)
    }
    
    func setPhotoReturning(completion: @escaping () -> ()) {
        overviewVC.photoReturningCompletion = completion
    }
    
    func selectedCell(frame: CGRect, XOffset: CGFloat) {
        
        let contentOffset = bubbleVC.collectionView.contentOffset
        var f = frame
        
        f.origin.y = f.origin.y - contentOffset.y
        
        overviewVC.initialPhotoFrame = f
        f.origin.y = f.origin.y + view.safeAreaInsets.top
        f.origin.x = f.origin.x + XOffset
        overviewVC.destinationFrame = f
    }
    
    func seeAllText(str:String) {
        resignKeyboard()
        let vc = SeeAllTextViewController()
        vc.text = str
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func resignKeyboard() {
        self.textView.resignFirstResponder()
    }
    
//    func profileOverview() {
//        let vc = ProfileViewController()
//        vc.profile = self.profile
//
//        self.present(vc, animated: true, completion: nil)
//    }
    
    func viewPicture(profile: profileAppearance, selectedImage: String) {
        if let converseList = ConverseModel.getConverseList(forKey: profile.userConverseKeyID) {
            
            overviewVC.configUI(with: profile, converseList: converseList, selectedImage: selectedImage)
            overviewVC.delegate = self
            overviewVC.modalPresentationStyle = .overFullScreen
            self.present(overviewVC, animated: true) {
                self.bubbleVC.shouldScrollToBottom = false
            }
        }
    }
    
}
