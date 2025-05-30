//
//  UserDefaultsManager.swift
//  E-Wallet
//
//  Created by Prashant Kumar on 07/02/24.
//

import Foundation


class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    enum UserDefaultsKey: String {
        
        case vehicleNumber
        case vehicleId
        case uploadImage
        
        case attendance_Status
        case shift_Status
        case superCompanyID
        
      
        
        // Add more keys as needed
    }
    
    // Save value to UserDefaults
    func saveValue(_ value: Any, forKey key: UserDefaultsKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    // Get value from UserDefaults
    func getValue(forKey key: UserDefaultsKey) -> Any? {
        return userDefaults.value(forKey: key.rawValue)
    }
    
    // Remove value from UserDefaults
    func removeValue(forKey key: UserDefaultsKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
//// Save value
//UserDefaultsManager.shared.saveValue("John", forKey: .verifyToken)
//
//// Get value
//if let username = UserDefaultsManager.shared.getValue(forKey: .username) as? String {
//    print("Username: \(username)")
//} else {
//    print("Username not found")
//}
//
//// Remove value
//UserDefaultsManager.shared.removeValue(forKey: .username)
