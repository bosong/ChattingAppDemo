//
//  converstion.swift
//  EZChattingApp
//
//  Created by 佘上翎18637 on 2018/11/9.
//  Copyright © 2018年 佘上翎18637. All rights reserved.
//

import UIKit

class ConverseModel: NSObject, NSCoding {
    
    var converse: [ConverseMessage] = []
    required convenience init?(coder aDecoder: NSCoder) {
        
        let converse = aDecoder.decodeObject(forKey: "converse") as! [ConverseMessage]

        self.init(converse: converse)
    }
    
    init(converse: [ConverseMessage]) {
        self.converse = converse
    }

    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(converse, forKey: "converse")
    }
    
    static func getImgList(from converseList: [ConverseModel]) -> [ImgInfo] {
        var imgList:[ImgInfo] = []
        for converseModel in converseList {
            for converse in converseModel.converse {
                if let img = converse.image {
                    let imgInfo = ImgInfo.init(id: converse.identifier, image: img)
                    imgList.append(imgInfo)
                }
            }
        }
        return imgList
    }
    
    func markTime() -> String {
        guard let date = converse.first?.time else {
            return ""
        }
        let calender = Calendar(identifier: Calendar.Identifier.buddhist)
        
        var str = ""
        if calender.isDateInToday(date) {
            str = "Today"
        }
        else if calender.isDateInYesterday(date) {
            str = "Yesterday"
        } else {
            str = ConverseModel.dateFormatter.string(from: date)
        }
        return str
    }
    
    
    static func getData(_ converse: [ConverseMessage]) -> [ConverseModel] {
       
        var dateSet:[String] = []
        var arr:[ConverseModel] = []
        let sorted = converse.sorted { (c1, c2) -> Bool in
            c1.time < c2.time
        }
        
        sorted.forEach { (c) in
            let str = ConverseModel.dateFormatter.string(from: c.time)
            if !dateSet.contains(str) {
                dateSet.append(str)
            }
        }
        
        dateSet.forEach { (date) in
            let converse = sorted.filter({ (c) -> Bool in
                c.timeStr() == date
            })
            let model = ConverseModel(converse: converse)
            arr.append(model)
        }
        
        return arr
        
    }
    
    static var dateFormatter:DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter
        }
    }
    
    static func save(converseList: [ConverseModel], forKey key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: converseList)
        UserDefaults.standard.set(data, forKey: key)
        print("save by key: \(key)")
        
    }
    
    static func getConverseList(forKey key: String) -> [ConverseModel]? {
        
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        
        if let arr = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ConverseModel] {
//            print("get by key: \(key)")
            return arr
        }
        return nil
        
    }
}
enum ConverseContentType: Int {
    case image = 0
    case text = 1
    case none = 2
}

class ConverseMessage: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(source.rawValue, forKey: "source")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(identifier, forKey: "identifier")
        aCoder.encode(contentType.rawValue, forKey: "contentType")
        aCoder.encode(estimatedSize, forKey: "estimatedSize")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let source = aDecoder.decodeInteger(forKey: "source")
        let text = aDecoder.decodeObject(forKey: "text") as! String
        let image = aDecoder.decodeObject(forKey: "image") as? UIImage
        let time = aDecoder.decodeObject(forKey: "time") as! Date
        let identifier = aDecoder.decodeObject(forKey: "identifier") as! String
        let contentType = aDecoder.decodeInteger(forKey: "contentType")
       

        self.init(source: ConverseMessage.Source(rawValue: source)!, text: text, image: image, time: time, identifier: identifier, contentType: ConverseContentType(rawValue: contentType)!)
        
    }
    
    convenience init(converse: ConverseMessage) {

        self.init(source: converse.source, text: converse.text, image: converse.image, time: converse.time, identifier: converse.identifier, contentType: converse.contentType)
    }
    
    var source: Source
    var text: String = ""
    var image: UIImage?
    var time: Date
    var identifier = ""
    var contentType: ConverseContentType = .none
    var estimatedSize:CGSize?
    init(source: ConverseMessage.Source, text: String, image: UIImage?, time: Date, identifier: String, contentType: ConverseContentType) {
        self.source = source
        self.text = text
        self.time = time
        self.identifier = identifier
        self.contentType = contentType
        
        self.image = image
        self.estimatedSize = image?.size
    }
    
    enum Source: Int {
        case user = 0
        case partner = 1
    }
    
    func timeStr() -> String {
        return ConverseModel.dateFormatter.string(from: time)
    }
    
    func isLoading() -> Bool {
        
        switch self.contentType {
        case .image:
            return image == nil
        case .text:
            return text == ""
        default:
            return false
        }
    }
    
    static func converse() -> [ConverseMessage] {
        return Examples.converse1
    }
}
