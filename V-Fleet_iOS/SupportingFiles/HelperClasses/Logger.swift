//
//  Logger.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 22/09/20.
//  Copyright © 2020 Kamaljeet Punia. All rights reserved.
//

import UIKit


enum LogType: String {
    case error
    case warning
    case success
}

class Logger {

 static func printLog(_ logType: LogType,_ message: String){
        switch logType {
        case LogType.error:
            print("\n🛑 Error: \(message)\n")
        case LogType.warning:
            print("\n⚠️ Warning: \(message)\n")
        case LogType.success:
            print("\n📗 Success: \(message)\n")
        }
    }

}
