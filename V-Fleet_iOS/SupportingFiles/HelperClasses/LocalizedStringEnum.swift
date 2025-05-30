//
//  LocalizedStringEnum.swift
//  TimeApp
//
//  Created by Tina on 02/04/20.
//  Copyright © 2020 Tina. All rights reserved.
//

import Foundation

enum LocalizedStringEnum:String {
    case appName = "V-Fleet"
    case networkNotReachable
    case somethingWentWrong
    case sessionExpired
    case unauthenticatedAccess

    
    //MARK:- Alerts
    case ok
    case yes
    case no
    case cancel
    
    case logoutAlert
    
    case enterFullName
    case enterValidEmail
    case enterValidPassword
    case confirmAgeAbove18
    case confirmTerms
    
    //step 1
    case enterPhoneNo
    case enterPassword
    case enterTransactionPin
    
    case enterFirstName
    case enterLastName
    case enterDisplayName
    case enterValidPhoneNo
    case selectCategory
    case enterConfirmPassword
    case passwordNotMatch
    
    case selectIdentityProofType
    case selectIdentityProof
    
    case enterProfileName
    case enterAboutYou
    case uploadHeadshot
    case uploadBodyImage
    
    case bankName
    case enterAccHolderName
    case enterAccNumber
    case enterIfsc
    case enterRoutingNo
    
    case enterPostDescription
    case selectPostType
    case selectPaidType
    case enterAmount
    case chooseMedia
    
    case validFirstName
    case enterEmail
    case validName
    case enterName
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: self.rawValue)
    }
}



