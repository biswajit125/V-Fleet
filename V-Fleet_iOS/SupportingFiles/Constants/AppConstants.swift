//
//  AppConstants.swift
//  Whetness
//
//  Created by Bishwajit kumar on 23/07/24.
//  Copyright © 2020 Kamaljeet Punia. All rights reserved.
//

import Foundation

enum APIEnvironment{
    case development
    case production
    case staging
}

enum BiometricType {
    case none
    case touchID
    case faceID
}

enum AppTarget: String {
    case driver = "PetDispatchDriver"
    case customer = "PetDisptachCustomer"
    
    var ApiType: String {
        switch self {
        
        case .driver: return "Where To Pet Dispatch Driver"
        case .customer: return "Where To Pet Dispatch"
        }
    }
}

struct AppConstants {
    
    static let deviceType: Int = 2 //1-Android 2-iOS
    
    //App environment
    static let environment: APIEnvironment = .staging //.development
    
    //Base url
    struct Urls {
//        https://portal.vareli.co.in/fleet-mate/
    //Local url
//         http://45.64.222.18:8083/fleet-mate-v3/
        //Step::=> 0.3 Define request base url
        static var apiBaseUrl: String {
            switch AppConstants.environment {
            case .development:
                return "http://192.168.13.62:8080/fleet-mate/"//"https://portal.vareli.co.in/fleet-mate/" //"http://192.168.8.28:8080/FleetManagement-sass/"
            case .production:
                return "https://portal.vareli.co.in/fleet-mate/"//"http://192.168.8.28:8080/FleetManagement-sass/"
            case .staging:
                return "http://45.64.222.18:8083/fleet-mate-v3/"//"http://192.168.8.28:8080/FleetManagement-sass/"
            }
        }
        
        static var socketUrl: String {
            switch AppConstants.environment {
            case .development:
                return "http://164.52.223.66:3001"
            case .production:
                return "http://164.52.223.66:3001"
            case .staging:
                return "http://101.53.158.135:3001"
            }
        }
    }
    
    static var currentTarget: AppTarget {
        if let targetName = Bundle.main.infoDictionary?["TargetName"] as? String {
            return AppTarget(rawValue: targetName) ?? .customer
        }
        return .customer
    }
    
    static var kGoogleMapBrowserApiKey: String {
      get {
        
        let resource = self.currentTarget == .customer ? "GoogleService-Info" : "GoogleService-Info-driver"
        
        guard let filePath = Bundle.main.path(forResource: resource, ofType: "plist") else {
          fatalError("Couldn't find file '\(resource).plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in '\(resource).plist'.")
        }
        return value
      }
    }
    
    struct NotificationObserverKeys {
        static let UnauthenticatedAccess = "UnauthenticatedAccess"
        static let AuthenticatedAccess = "AuthenticatedAccess"
        static let UserLoggedIn = "UserLoggedIn"
        static let UserLoggedOut = "UserLoggedOut"
        
        static let DidReceiveResponse = "DidReceiveResponse"
        static let ReCalculateTimer = "ReCalculateTimer"
    }
    
    //User default keys
    
    struct APIHeaders {
        static let headers: [String: Any] = [
            "Content-Type": "application/json",
           // "appversion": "1",
            "Accept": "application/json"
        ]
       // let boundary = "Boundary-\(UUID().uuidString)"
        static let multipartHeaders: [String: Any] = [
           
            "Content-Type": "multipart/form-data;boundary=\(UUID().uuidString)",
            //"appversion": "1",
            "Accept": "multipart/form-data",
            
        ]
        static let headersWithAuthToken: [String: Any] = {
            return [
                "Content-Type": "application/json",
                "Accept": "application/json",
               // "appversion": "1"
            ]
        }()
    }
    
    struct UserDefaultsKey {
        
        static let currentUser = "currentUser"
        static let deviceToken = "deviceToken"
        static let booking = "booking"
        static let startedScheduleRideID = "startedScheduleRideID"
        static let currentLoginTypeUser = "currentLoginTypeUser"
        static let walkthrough = "walkthrough"
        static let rememberPassword = "rememberPassword"
        static let rememberUserName = "rememberUserName"
        
//        static var pickupLocation = "pickupLocation"
//        static var destinationLocation = "destinationLocation"
    }
    
    static var SelectionCount : Int? = 0
    
    static let appName = "V-Fleet"
    static let alphabetUppercaseNumeric = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    static let alphabetUppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        static let alphabetSpaceSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        static let alphabetLastNameSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-"
        static let alphaNumericSpaceSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 "
    
    //User default keys
    struct UserDefault {
        static let currentUser = "currentUser"
        static let phone = "phone"
        static let getUserDetailData = "getUserDetailData"
        static let authToken = "authToken"
        
        
    }
}


enum DayConstant: Int {
    case incoming = 0, outgoing, pending
    
    var description : String {
        switch self {
        case .incoming: return "EXPECTED"
        case .outgoing: return "SEND"
        case .pending: return "PENDING"
        }
    }
}
enum AlertsNames: String {
    case warning = "Warning"
    case success = "Success"
    case error = "Error"
    case v_Fuel = "V-Fuel"
}
