//
//  AppFont.swift
//  TimeApp
//
//  Created by Kamaljeet Punia on 09/04/20.
//  Copyright © 2020 Tina. All rights reserved.
//

import Foundation
import UIKit

//MARK: Enumeration
enum AppFont: String {
    
    case regular = "Roboto-Regular"
    case bold = "OpenSans-Bold"
    case light = "Roboto-Light"
    case medium = "Roboto-Medium"
    case semiBold = "Roboto-SemiBold"
    
    func fontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}

enum AppColor{
    static let fontBlue = UIColor(named: "FontBlue")
    static let fontGrey = UIColor(named: "labelColor")
    static let appBlue = UIColor(named: "AppBlue")
    static let boldLabel = UIColor(named: "BoldLabel")
    static let tabBar = UIColor(named: "TabBar")
    static let appWhite = UIColor(named: "AppWhite")
    static let calenderDayfont = UIColor(named: "CalenderDayfont")
    static let timeSloteVw = UIColor(named: "TimeSloteVw")
    static let notificationPopUp = UIColor(named: "NotificationPopUp")
    static let segmentSelect = UIColor(named: "SegmentSelect")
    static let popUp = UIColor(named: "PopUp")
    static let selectedCellColour = UIColor(named: "SelectedCellColour")
    static let cellenderWeak = UIColor(named: "CellenderWeak")
    static let collCell = UIColor(named: "CollCell")
    static let timeSlotelbl = UIColor(named: "TimeSlotelbl")
    static let vwBlue = UIColor(named: "vwBlue")
    static let vwGray = UIColor(named: "vwGray")
    
    
    
    

   
  


}

enum StoryBoard{
    static let main = UIStoryboard(name: "Authentication", bundle: nil)
    static let home = UIStoryboard(name: "Home", bundle: nil)
    static let myJobs = UIStoryboard(name: "MyJobs", bundle: nil)
    static let cases = UIStoryboard(name: "Cases", bundle: nil)
    static let menu = UIStoryboard(name: "Menu", bundle: nil)
}
