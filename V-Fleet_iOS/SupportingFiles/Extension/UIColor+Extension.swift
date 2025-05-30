//
//  UIColor+Extension.swift
//  TimeApp
//
//  Created by Kamaljeet Punia on 14/08/20.
//  Copyright © 2020 Tina. All rights reserved.
//

import UIKit

enum ColorEnum: String {
    case skyBlue = "skyblue"
    case green
    case blue
    
    func getColor() -> UIColor {
        switch self {
            
        case .skyBlue:
            return #colorLiteral(red: 0.3882352941, green: 0.8078431373, blue: 0.9647058824, alpha: 1)
        case .green:
            return #colorLiteral(red: 0.5333333333, green: 0.7725490196, blue: 0.3647058824, alpha: 1)
        case .blue:
            return #colorLiteral(red: 0.02352941176, green: 0.5568627451, blue: 0.7882352941, alpha: 1)
        @unknown default:
            return #colorLiteral(red: 0.02352941176, green: 0.5568627451, blue: 0.7882352941, alpha: 1)
        }
    }
}
