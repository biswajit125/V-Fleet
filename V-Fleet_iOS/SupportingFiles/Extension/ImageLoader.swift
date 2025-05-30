//
//  ImageLoader.swift
//  iWantIt iOS
//
//  Created by Prashant Kumar on 28/07/24.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func imageURL(_ url: String) {
        // Create and configure the activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the activity indicator to the image view
        self.addSubview(activityIndicator)
        
        // Center the activity indicator in the image view using Auto Layout constraints
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // Start animating the activity indicator
        activityIndicator.startAnimating()
        
        // Load the image using SDWebImage
        self.sd_setImage(with: URL(string: url)) { (image, error, cacheType, url) in
            activityIndicator.stopAnimating()
        }
    }
}

