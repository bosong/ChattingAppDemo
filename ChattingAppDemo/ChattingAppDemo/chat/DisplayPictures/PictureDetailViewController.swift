//
//  PictureDetailViewController.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/12/5.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class PictureDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var imgList:[ImgInfo] = []
    var selectedImgIndex = 0 {
        didSet {
            currentIndex = selectedImgIndex
        }
    }
    
    var dismissWithAnimation = true
    var currentIndex = 0
    var currentImg: UIImage {
        get {
            return imgList[currentIndex].image
        }
    }
    private let cellID = "PictureCollectionViewCell"
    private var shouldScrollToSelectedImage = true
    
    var currentImgID: String {
        get {
            return imgList[currentIndex].id
        }
    }
    
    weak var delegate: BubbleCollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.utils.registCell(with: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldScrollToSelectedImage = true
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.collectionView.scrollToItem(at: IndexPath(item: self.selectedImgIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        collectionView.reloadData()
        CATransaction.commit()
        dismissWithAnimation = true
        collectionView.isHidden = false
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let scroll = shouldScrollToSelectedImage
        shouldScrollToSelectedImage = false
        configLayout()
        guard selectedImgIndex < imgList.count else {
            return
        }
        
        if scroll {
            collectionView.scrollToItem(at: IndexPath(item: selectedImgIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    func configLayout() {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let safeArea =  view.safeAreaLayoutGuide.layoutFrame
            layout.itemSize = CGSize(width: safeArea.width, height: safeArea.height)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
    }
    
}

extension PictureDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? PictureCollectionViewCell {
            cell.imgView.image = imgList[indexPath.item].image
            return cell
        }
        return UICollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x/collectionView.frame.width)
        
        delegate?.changePhoto(converseID: currentImgID)
    }
    
}
