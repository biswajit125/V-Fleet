//
//  UIApplication.swift
//  iTechnolabs
//
//  Created by Chitra on 17/12/22.
//

import Foundation
import UIKit

extension UIApplication {
    var appWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let window = delegate.window else { return nil }
            return window
        } else {
            // Fallback on earlier versions
            guard let delegate = UIApplication.shared.delegate else { return nil }
            return delegate.window ?? nil
        }
        
    }
}
