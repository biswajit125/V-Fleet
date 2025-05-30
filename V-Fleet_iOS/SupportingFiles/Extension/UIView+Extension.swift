//
//  UIView+Extension.swift
//  TimeApp
//
//  Created by Kamaljeet Punia on 08/04/20.
//  Copyright © 2020 Tina. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func roundCornerWithWidth() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func roundCornerWithHeight() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
    func addSubviewWithAnimation(_ view: UIView) {
        UIView.transition(with: self, duration: 0.40, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.addSubview(view)
        }) { (finish) in
            //
        }
    }
    
    func removeFromSuperViewWithAnimation() {
        if let superView = self.superview {
            UIView.transition(with: superView, duration: 0.40, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                self.removeFromSuperview()
            }) { (finish) in
                //
            }
        }
    }
    
    func addShadowWithRoundCorner(radius: CGFloat = 10, color: UIColor = .black, opacity: Float = 0.4, offSet: CGSize = .zero, shadowRadius: CGFloat = 10) {
        for layer in layer.sublayers ?? [] {
            if layer.isKind(of: CAShapeLayer.self) {
                layer.removeFromSuperlayer()
            }
            
        }
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = self.backgroundColor?.cgColor
        
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offSet
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        
        shadowLayer.borderWidth = 2.0
        shadowLayer.borderColor = UIColor.red.cgColor
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func addBottomRadiusWithShadow(radius: CGFloat = 10, color: UIColor = .black, opacity: Float = 0.4, offSet: CGSize = .zero, shadowRadius: CGFloat = 10){
        for layer in layer.sublayers ?? [] {
            if layer.isKind(of: CAShapeLayer.self) {
                layer.removeFromSuperlayer()
            }
            
        }
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
       
    }
    
    func addBottomRadius(radius : CGFloat = 10){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.fillColor = UIColor.white.cgColor
        mask.path = path.cgPath
        self.layer.mask = mask
            
    }
    
    func addBorderWithShadowAndCornerRadius(borderColor: UIColor) {
        layer.borderWidth = 1.5
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = 10.0
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.2
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    func performLeftToRightTransition() {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.layer.add(transition, forKey: nil)
    }
    
    func performRightToLeftTransition() {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.layer.add(transition, forKey: nil)
    }
    
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber]? = [2, 1], radius: CGFloat, color: UIColor, width: CGFloat) -> CALayer {
        let borderLayer = CAShapeLayer()

        borderLayer.strokeColor = color.cgColor
        borderLayer.lineDashPattern = pattern
        borderLayer.lineWidth = width
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath

        layer.addSublayer(borderLayer)
        return borderLayer
    }
    
    // For insert layer in Foreground
    func addBlackGradientLayerInForeground(colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
    
    // For insert layer in background
    func addBlackGradientLayerInBackground(colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    static func performTransitionOnWindow() {
        guard let window = UIWindow.key else {
            return
        }
        UIView.transition(with: window, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            //
        }, completion: nil)
    }
    
    func addBlurView(style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.9
        self.addSubview(blurEffectView)
    }
    
}

