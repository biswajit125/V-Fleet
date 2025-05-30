//
//  String+Extension.swift
//  TimeApp
//
//  Created by Kamaljeet Punia on 04/05/20.
//  Copyright © 2020 Tina. All rights reserved.
//

import Foundation

extension String {
    var isEmptyWithTrimmedSpace: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
}
