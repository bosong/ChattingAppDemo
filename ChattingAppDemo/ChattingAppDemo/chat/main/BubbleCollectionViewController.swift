//
//  BubbleCollectionViewController.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/22.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

class BubbleCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellID = ["BubbleCollectionViewCell","PhotoConverseCell"]
    var layout: UICollectionViewFlowLayout?
    weak var delegate: BubbleCollectionViewDelegate?
    var profileInfo: profileAppearance!
    let dataStore = DataStore()
    var shouldScrollToBottom = true
    var didChangeOrientation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.utils.registCells(with: cellID)
        self.collectionView.register(DateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "dateHeader")
        if let converseList = ConverseModel.getConverseList(forKey: profileInfo.userConverseKeyID) {
            dataStore.converseList = converseList
        } else {
            dataStore.converseList = ConverseModel.getData(ConverseMessage.converse())
            ConverseModel.save(converseList: dataStore.converseList, forKey: profileInfo.userConverseKeyID)
        }
        configFlowLayout()

    }

    
    func configFlowLayout() {
        
        layout = myFlowLayout()
        layout?.minimumLineSpacing = 12
        collectionView.contentInset.top = 8
        collectionView.contentInset.bottom = 15
        
        layout?.estimatedItemSize = CGSize(width: screenWidth - collectionView.contentInset.right - collectionView.contentInset.left - 4, height: 30)
        layout?.headerReferenceSize = CGSize(width: screenWidth , height: 44)
        collectionView.collectionViewLayout = layout!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let last = dataStore.converseList.count - 1
        
        guard shouldScrollToBottom else {
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.collectionView.scrollToItem(at: IndexPath(item: self.dataStore.converseList[last].converse.count - 1, section: last) , at: .top, animated: false)
        }
        
        collectionView.reloadData()
        CATransaction.commit()

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        didChangeOrientation = true
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        safeAreaInset = self.view.safeAreaInsets.left * 2
        if didChangeOrientation {
            configFlowLayout()
            layout?.invalidateLayout()
            didChangeOrientation = false
            
        }
        
    }
    func send(converse: ConverseMessage) {
        scrollToBottom()
        dataStore.append(converse, saveWith: profileInfo)
        
        insertCell()
    }
    
    func scrollToBottom() {
        let last = dataStore.lastIndexPath()
        collectionView.scrollToItem(at: last, at: .bottom, animated: false)
    }
    
    func updateCollectionViewlayout(adjustment: CGFloat, showKeyBoard: Bool) {
        let originalContentOffsetY = collectionView.contentOffset.y
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            
            let newContentOffsetY = originalContentOffsetY + adjustment * (showKeyBoard ? 1 : -1)
            let topBound = self.collectionView.contentInset.top * -1
            let bottomBound = self.collectionView.contentInset.bottom + self.collectionView.contentSize.height - self.collectionView.frame.height
            self.collectionView.contentOffset.y = min(max(newContentOffsetY, topBound), bottomBound)
            
            UIView.setAnimationsEnabled(true)
        }
        
        UIView.setAnimationsEnabled(false)
        self.view.superview?.superview?.layoutIfNeeded()
        CATransaction.commit()
    }
    
    private func insertCell() {
        let bottomOffset = collectionView.contentSize.height - collectionView.contentOffset.y
        let lastSection = dataStore.converseList.count - 1
        let indexPath = IndexPath(item: dataStore.converseList[lastSection].converse.count - 1, section: lastSection)
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            let newContentSize =  self.collectionView.collectionViewLayout.collectionViewContentSize
            let newContentOffest = CGPoint(x: 0, y: newContentSize.height - bottomOffset)
            self.collectionView.setContentOffset(newContentOffest, animated: false)
            UIView.setAnimationsEnabled(true)
        }
        UIView.setAnimationsEnabled(false)
        collectionView.numberOfItems(inSection: 0)
        self.collectionView.insertItems(at: [indexPath])
        CATransaction.commit()
    }
    
    func turnTo(converse id: String) {
        for cell in collectionView.visibleCells {
            guard let c = cell as? PhotoConverseCell else {
                continue
            }
        c.itsMyTurn(c.converse?.identifier == id)
        }
        

    }
}
extension BubbleCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataStore.converseList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataStore.converseList[section].converse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let converse = dataStore.loadConverseRating(at: indexPath)?.converse else {
//            return SuperBubbleCell()
//
//        }
        let converse = dataStore.getData(at: indexPath)
        var cell = SuperBubbleCell()
        
        if converse.contentType == .image, let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID[1], for: indexPath) as? PhotoConverseCell {
            if let size = converse.estimatedSize {
                photoCell.estimatedSize = size
            }
            cell = photoCell
        
        }
        else if let bubble = collectionView.dequeueReusableCell(withReuseIdentifier:cellID[0], for: indexPath) as? BubbleCollectionViewCell {
            cell = bubble
        }
        cell.delegate = self.delegate
        cell.configUI(message: converse, profileInfo: profileInfo)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? SuperBubbleCell else { return }
        let converse = dataStore.converseList[indexPath.section].converse[indexPath.row]
        cell.configUI(message: converse, profileInfo: self.profileInfo)

        }
        

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.resignKeyboard()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "dateHeader", for: indexPath)
        
        if let h = header as? DateHeaderView {
            h.titleLabel.text = dataStore.converseList[indexPath.section].markTime()
            h.resetTitleFrame()
        }
        
        return header
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        layout?.sectionHeadersPinToVisibleBounds = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        layout?.sectionHeadersPinToVisibleBounds = false
    }
}



