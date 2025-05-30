//
//  AppDelegate+Initializations.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 22/09/20.
//  Copyright © 2020 Kamaljeet Punia. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

///Define any method here which we want to use in app delegate & call it from app delegate class.
extension AppDelegate {
    
    func initializeLibraries() {
        IQKeyboardManager.shared.enable = true
        self.initializeReachability()
    }

}
