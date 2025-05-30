//
//  LoginRequestModel.swift
//  Vstock
//
//  Created by Chitra on 30/06/23.
//

import Foundation

struct LoginRequestModel: Codable {
    var mobile: String?
   // var password: String?
    
    var validationMsg: String? {
        if mobile?.isEmptyWithTrimmedSpace == true {
            return "Please enter phone number."
        }
        return nil
    }
}

