//
//  AppDelegate.swift
//  InstaProtect
//
//  Created by itechnolabs on 06/10/22.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var networkAlertLabel: UILabel?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
         //Override point for customization after application launch.
        let style = UserDefaults.standard.value(forKey: "onClickSwitch") as? String ?? ""
        if style == "dark" {
            window?.overrideUserInterfaceStyle = .dark
        
        }else {
            window?.overrideUserInterfaceStyle = .light
        }
        return true
    }
    
    func setUpTextField(){
//        UILabel.appearance(whenContainedInInstancesOf: [UITextField.self]).textColor = AppColor.placeholder
        UITextField.appearance().tintColor = AppColor.boldLabel
    }
}

