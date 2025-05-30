//
//  UITextField+Regex.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 22/09/20.
//  Copyright © 2020 Kamaljeet Punia. All rights reserved.
//

import UIKit

public enum TextFieldRegex {
    case Alphabetics
    case Numeric
    case AlphaNumeric
    case CustomCharacterSet
}

let numberCharacterSet = NSCharacterSet(charactersIn:"0123456789").inverted
let customCharacterSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ _-").inverted

// MARK: - CUSTOM TEXTFIELD TYPE
public enum CustomTextFieldType: Int, Codable {
    case text = 0
    case datePicker = 1
    case picker = 2
    case imagePicker = 3
    case email = 4
    case numeric = 5
    case phoneNumber = 6
}

// MARK: - REGULAR EXPRESSIONS
extension UITextField {
    //To enable emojis pass true for emoji parameter and regex should be nil.
    
    func regex(_ range: NSRange, _ string: String, _ regex: TextFieldRegex? = nil, emojis: Bool = false, maxLength: Int = 500) -> Bool {
        
        if string == "" { return true } //Backspace
        
        //Length
        let currentString: NSString = self.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        let isValidLength = newString.length <= maxLength
        if !isValidLength {
            return false
        }
        
        //Emojis
        if !emojis {
            if !string.canBeConverted(to: String.Encoding.ascii) {
                return false
            }
        }
        
        //Regex
        if regex == nil {
            return true
        }
        switch regex! {
        case .Alphabetics:
            if string == " " { return true }
            if (string.rangeOfCharacter(from: CharacterSet.letters) == nil) {
                return false
            }
        case .Numeric:
            if (string.rangeOfCharacter(from: numberCharacterSet) != nil) {
                return false
            }
        case .AlphaNumeric:
            if string == " " { return true }
            if (string.rangeOfCharacter(from: CharacterSet.alphanumerics) == nil) {
                return false
            }
        case .CustomCharacterSet:
            if (string.rangeOfCharacter(from: customCharacterSet) != nil) {
                return false
            }
        }
        return true
    }
}
