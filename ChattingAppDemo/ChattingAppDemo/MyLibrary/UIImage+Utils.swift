//
//  UIImage+Utils.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/23.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import UIKit

extension Utils where Base == UIImage {
    
    /// Create a image with color and size.
    init(color: UIColor, size: CGSize) {
        let rect = CGRect(x: 0.0, y: 0.0, width:  size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.base = image!
    }
    
    @available(iOS 8.0, *)
    var asQRCodeMessage: String? {
        get {
            guard let ciImage = CIImage.init(image: base) else { return nil }
            let options = [
                CIDetectorAccuracy: CIDetectorAccuracyHigh,
                CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1
            ] // 1 default
            guard let qrcodeDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options) else { return nil }
            
            let features = qrcodeDetector.features(in: ciImage)
            
            guard let qrcodeFeature = features.first(where: {$0 is CIQRCodeFeature}) as? CIQRCodeFeature else { return nil }
            return qrcodeFeature.messageString
        }
    }
    
    func pixelColor(at point: CGPoint) -> UIColor {
        

        if let cg = base.cgImage {
            return cg.utils.getPixelColor(at: point)
        }
        return UIColor.clear
        
    }
    
    
    func checkValidation(of point: CGPoint) -> Bool {
        
        if point.x < 0 || point.y < 0 {
            return false
        }
        
        if point.x > base.size.width || point.y > base.size.height {
            return false
        }
        return true
    }
    
    var base64Str: String? {
        get {
            let data = base.jpegData(compressionQuality: 0.4)
            let str = data?.base64EncodedString(options: .lineLength64Characters)
            return str
        }
    }
    
    func limited(by maxSize: CGSize) -> UIImage {
        
        let rate = maxSize.height/maxSize.width
        let imgRate = base.size.height/base.size.width
        var scale:CGFloat = 1.0
        if imgRate > rate {
            scale = maxSize.height/base.size.height
        } else {
            scale = maxSize.width/base.size.width
        }
       
        if scale >= 1 {
            return base
        }
        
        if let data = base.jpegData(compressionQuality: scale) ,let img = UIImage(data: data) {
            return img
        }
        return base
        
    }
    
}

/// Extend UIImage with `utils` proxy.
extension UIImage: UtilsCompatible { }
