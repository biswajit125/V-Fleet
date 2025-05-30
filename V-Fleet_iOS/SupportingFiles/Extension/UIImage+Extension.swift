//
//  UIImage+Extension.swift
//  TimeApp
//
//  Created by Kamaljeet Punia on 09/04/20.
//  Copyright © 2020 Tina. All rights reserved.
//

import UIKit

extension UIImage {
    
    var MAX_IMAGE_UPLOAD_SIZE: Int {
        return Int(0.5*1024*1024)//500 kb
    }
    
    func gradientTintColor(_ colorsArray: [UIColor]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1, y: -1)
        
        context.setBlendMode(.normal)
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        
        // Create gradient
        let cgcolorsArray: [CGColor] = colorsArray.map{$0.cgColor}.reversed()
        let colors = cgcolorsArray as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: space, colors: colors, locations: nil)
        
        // Apply gradient
        context.clip(to: rect, mask: self.cgImage!)
        context.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: self.size.height), options: .drawsAfterEndLocation)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return gradientImage!
    }
    
    func resizeByByte() -> Data? {
        var compressQuality: CGFloat = 1
        var imageData = Data()
        var imageByte = self.jpegData(compressionQuality: 1)?.count
        
        while imageByte! > MAX_IMAGE_UPLOAD_SIZE {
            imageData = self.jpegData(compressionQuality: compressQuality) ?? Data()
            imageByte = self.jpegData(compressionQuality: compressQuality)?.count
            compressQuality -= 0.1
            if compressQuality < 0 {
                return imageData
            }
        }
        
        if imageData.count == 0 {
            imageData = self.jpegData(compressionQuality: 1) ?? Data()
        }
        return imageData
        
    }
    
    func resize(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
