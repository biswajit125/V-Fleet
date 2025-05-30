//
//  UIImageView+Extension.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 30/03/21.
//  Copyright © 2021 Kamaljeet Punia. All rights reserved.
//

import UIKit

extension UIImageView {
    func blurImage() {
        guard let image = self.image else {
            return
        }
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: image)
        let originalOrientation = image.imageOrientation
        let originalScale = image.scale
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(10.0, forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage
        
        var cgImage:CGImage?
        
        if let asd = outputImage
        {
            cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
        }
        
        if let cgImageA = cgImage
        {
            let blurImage = UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
            self.image = blurImage
        }
        
    }
}
