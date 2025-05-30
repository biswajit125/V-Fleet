//
//  UILabel+Extension.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 23/03/21.
//  Copyright © 2021 Kamaljeet Punia. All rights reserved.
//

import UIKit

extension UILabel {
    func underlineText() {
        guard let text = self.text,
              let font = self.font else {
            return
        }
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: font
        ]
        let underlineAttriString = NSAttributedString(string: text,
                                                      attributes: attributes)
        self.attributedText = underlineAttriString
    }
}
