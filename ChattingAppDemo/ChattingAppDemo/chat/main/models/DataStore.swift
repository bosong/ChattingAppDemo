//
//  DataStore.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/28.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

class DataStore {
    var converseList = ConverseModel.getData(ConverseMessage.converse())
    var imgList:[UIImage] = []
    
    public var numberOfConverse: Int {
        return converseList.count
    }
    
    public func getData(at indexPath: IndexPath) -> ConverseMessage {
        return converseList[indexPath.section].converse[indexPath.item]
    }
    
    public func lastIndexPath() -> IndexPath {
        let last = converseList.count - 1
        let list = converseList[last].converse
        return IndexPath(item: list.count - 1, section: last)
    }
    
    
    public func append(_ newElement: ConverseMessage, saveWith profile: profileAppearance? = nil) {
        let last = converseList.count - 1
        converseList[last].converse.append(newElement)
        if let p = profile {
            ConverseModel.save(converseList: converseList, forKey: p.userConverseKeyID)
        }
        
    }

//
//    public func loadConverseRating(at indexPath: IndexPath) -> DataLoadOperation? {
//        if (0..<converseList.count).contains(indexPath.section) {
//            return DataLoadOperation(converseList[indexPath.section].converse[indexPath.item])
//        }
//        return .none
//    }

}

//
//class DataLoadOperation: Operation {
//    var converse: ConverseMessage
//    var loadingCompleteHandler: ((ConverseMessage) -> Void)?
//        private let _converse: ConverseMessage
//
//    init(_ converse: ConverseMessage) {
//        _converse = converse
//        self.converse = ConverseMessage(converse: _converse)
//        self.converse.image = nil
//    }
//
//    override func main() {
//        if isCancelled { return }
//
////        let randomDelatTime = 500
////        if self.converse.contentType == .image {
////            usleep(useconds_t(randomDelatTime * 1000))
////        }
////
//
//        if isCancelled { return }
//        converse.image = _converse.image
//
//        if let loading = loadingCompleteHandler {
//            DispatchQueue.main.async {
//                loading(self._converse)
//            }
//        }
//    }
//}
