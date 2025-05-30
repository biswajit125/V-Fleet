//
//  Proxy.swift
//  DiabetesApp
//
//  Created by Visions on 10/08/20.
//  Copyright © 2020 Visions. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
//import NVActivityIndicatorView

//For Get thumbnail image from video
import AVFoundation
import SwiftUI

final class Proxy: NSObject {
    //MARK:- Properties
    static let sharedInstance = Proxy()
    private override init() { }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var msgLabel : UILabel?
    let charsWithoutSpecialChar = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_. \n"
    let emailOrPasswordCharacter = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789~!@#$%^&*()_+?/.<>|"
    let emailCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_@."
    let numericCharacterSet = "0123456789"
    let aToZ = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    let checkArabicPredicate = NSPredicate(format: "SELF MATCHES %@", "(?s).*\\p{Arabic}.*")
    var currentDate = Date()
    let dateFormatter = DateFormatter()
    var tempToken = String()
    var dayComponent = DateComponents()
    var userId = String()
    var otp = String()
    var timer: Timer!
    let refreshControl = UIRefreshControl()
    var businessName, businessProfile: String?
  
    
    //Error Messages
    private enum Error: String, CaseIterable {
        case success  = "An action was successfully completed"
        case error    = "An error has occured"
        case warning  = "A warning has occured"
        
        static let grouped: [[Error]] = [[.success, .error, .warning,]]
    }
    
    //MARK:- Get Thumbnail image from video
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            debugPrint(error)
        }

        return nil
    }
    
    //MARK:- Get Safe Area Height
    func getSafeAreaHeight() -> CGFloat {
        var safeAreaHeight = CGFloat()
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            safeAreaHeight = bottomPadding ?? 0
            return safeAreaHeight
        }
        return 0
    }
    
    //MARK:- Restrict Fields without Spectial Characters Validation
    func restrictFields(_ string: String, isEmailOrPassword: Bool) -> Bool {
        let cs = NSCharacterSet(charactersIn: isEmailOrPassword ? emailOrPasswordCharacter:charsWithoutSpecialChar).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        if string == " " {
            return false
        } else {
            return (string == filtered)
        }
    }
    
    //MARK:- Get Calender Object
    func getCalenderObj() -> Calendar {
        let theCalendar = Calendar.current
        return theCalendar
    }
    
    func getShortMonthName(month:Int) -> String {
        debugPrint(month)
        let fmt = DateFormatter()
        let monthName = fmt.shortMonthSymbols[month]
        return monthName
    }
    
    func getMonthName(month:Int) -> String {
        let fmt = DateFormatter()
        let monthName = fmt.monthSymbols[month]
        return monthName
    }
    
    //MARK:- Get Weekday Name
    func weekdayName() -> String {
        let date = Date()
        dateFormatter.dateFormat  = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek
    }
    
    //MARK:- Set Applicaiton's Badge count
    func setApplicationBadgeCount(_ badgeCount: Int) {
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = badgeCount
    }
    
    
    func setAstrickPlaceHolder(_ textfield : [UITextField]){
        for each in textfield{
            let passwordAttriburedString = NSMutableAttributedString(string: each.placeholder ?? "")
                let asterix = NSAttributedString(string: "*", attributes: [.foregroundColor: UIColor.red])
                passwordAttriburedString.append(asterix)
                        
            each.attributedPlaceholder = passwordAttriburedString
        }
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let getFormattedStr = formatter.string(from: date)
        debugPrint(getFormattedStr)
        return getFormattedStr
    }
    
    //MARK:- Scroll UITableView at last index
    func scrollTblVwToBottom(_ tblVW: UITableView, count: Int){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: count-1, section: 0)
            tblVW.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    //MARK:- Random String Generate by Length
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    //MARK:- Random Generate User's Password
    func randomeGeneratePassword(_ length: Int) -> String {
        let passwordChacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let randomePasword = String((0..<length).compactMap{ _ in passwordChacters.randomElement() })
        debugPrint(randomePasword)
        return randomePasword
    }
    
    //MARK:- Get Current Date / Time
    func getCurrentDateTime() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateStr = formatter.string(from: currentDate)
        return currentDateStr
    }
    
    //MARK:- Get Image Extension
    func getImgExtension(_ imgName: String) ->String {
        debugPrint(imgName)
        if !imgName.isBlank {
            let arrNames = imgName.components(separatedBy: ".")
            if arrNames.count > 0 {
                return arrNames.last ?? ""
            }
        }
        return ""
    }
    
    //MARK:- Decode JWT-Token
    func decode(jwtToken jwt: String) -> [String: Any] {
      let segments = jwt.components(separatedBy: ".")
    debugPrint(segments)
      return decodeJWTPart(segments[1]) ?? [:]
    }

    func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    func decodeJWTPart(_ value: String) -> [String: Any]? {
      guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }

      return payload
    }
    
    func loadDayName( day: Int) -> String{
        switch day {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "Nada"
        }
    }
    
    func getLastWeekDaysArray() -> [String] {
        let cal = Calendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        
        var days = [String]()
        
        for _ in 1 ... 7 {
            // get day component:
            let weekday = Calendar.current.component(.weekday, from: date)
            days.append(self.loadDayName(day: weekday))
            // move back in time by one day:
            date = cal.date(byAdding: .day, value: -1, to: date) ?? Date()
        }
        return days
    }
    
    func getLastWeekDatesArray() -> [Date] {
        let cal = Calendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        
        var days = [Date]()
        
        for _ in 1 ... 7 {
            // get day component:
            days.append(date)
            // move back in time by one day:
            date = cal.date(byAdding: .day, value: -1, to: date) ?? Date()
        }
        return days
    }
    
    //MARK:- Open Application with Predefine Method
    func useNewOpenUrl(_ urlStr: String) {
        let myUrl = urlStr
        if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        // or outside scope use this
        guard let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
//    func getFirebaseToken() ->String {
//        guard let token = UserDefaults.standard.string(forKey: UserDefaultsK.token) else { return "" }
//        return token
//    }
    
    //MARK:- hide & show ProgressHUD
//    func showProgressHUD() {
//        let loader = NVActivityIndicatorView(frame: currentController.view.frame , type:NVActivityIndicatorType.ballSpinFadeLoader , color: .black, padding:0.0 )
//        loader.startAnimating()
//        let activityData = ActivityData()
//        NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
//        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
//        NVActivityIndicatorView.DEFAULT_TEXT_COLOR = .black
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
//    }
//    
//    func hideProgressHUD() {
//        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
//    }
    
    //MARK:- Convert Data to Dictionary
    func convertToDictionary(txt: String) -> [String: Any]? {
        
        if let data = txt.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertDictionaryObjectToString(_ dictionary: NSMutableDictionary) -> String {
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        debugPrint(jsonString ?? "")
        return jsonString ?? ""
    }
    
    //MARK:- Find a value from array
    func findValueFromArray(value searchValue: String, in array: [String]) -> Int? {
        for (index, value) in array.enumerated() {
            if value == searchValue {
                return index
            }
        }
        return nil
    }
    
    //MARK:- Validate both Email & Password
    func isValidEmail(email:String?) -> Bool {
        guard email != nil else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    func isValidPassword(password:String?) -> Bool {
        guard password != nil else { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //MARK:- Return User's GraphQLFile Profile Image
    /**
     - Compress Image & Reduce Image's Size
     */
//    func getGraphQLUserProfile(_ selectedImg: UIImage, selectedImgName: String, imgParamName: String) -> GraphQLFile {
//        //let resizedImg = selectedImg.resized(withPercentage: 0.50)
//        let data = selectedImg.jpegData(compressionQuality: 0.5)!
//        let file = GraphQLFile(fieldName: imgParamName, originalName: selectedImgName, mimeType: "image/png" ,data: data)
//        debugPrint(data)
//        return file
//    }
    
    //MARK:- Voice calling method on number
    func voiceCallingMethod(_ number: String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //MARK:- Send Firebase Push Notification
//    func sendFirebasePushNotification(_ msg: String, token: String, notificationType: Int, receiverId: Int, notificationTitle: String) {
//        objFirebaseClass.dictNotification.setValue(msg, forKey: NotificationSentK.message)
//        objFirebaseClass.dictNotification.setValue(token, forKey: NotificationSentK.userToken)
//        objFirebaseClass.dictNotification.setValue(notificationType, forKey: NotificationSentK.notificationType)
//        objFirebaseClass.dictNotification.setValue(user.userId!, forKey: NotificationSentK.senderId)
//        objFirebaseClass.dictNotification.setValue(receiverId, forKey: NotificationSentK.receiverId)
//        objFirebaseClass.dictNotification.setValue(notificationTitle, forKey: NotificationSentK.title)
//
//        debugPrint(objFirebaseClass.dictNotification)
//        objFirebaseClass.sendFirebasePushNotification()
//    }
    
    //MARK:- Convert Strin to Dictionary object
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //MARK- Return both first name & last name from name string
    func returnFirsAndLastName(_ nameStr: String) ->(String, String) {
        if !nameStr.isBlank {
            debugPrint(nameStr)
            let arrName = nameStr.components(separatedBy: " ")
            debugPrint(arrName.count == 1 ? (arrName.first!, ""):(arrName.first!, arrName.last!))
            return arrName.count == 1 ? (arrName.first!, ""):(arrName.first!, arrName.last!)
        }
        return ("","")
    }
    
    //MARK:- Validate Username field
    func isValidUsername(Input:String) -> Bool {
        return Input.range(of: "\\A\\w{7,18}\\z", options: .regularExpression) != nil
    }
    
    //MARK:- Get Number of Characters from String
    func getNumberOfCharactersFromString(_ str: String, numberOfChars: Int) -> String {
        let index = str.index(str.startIndex, offsetBy: numberOfChars)
        let mySubstring = str[..<index]
        return "\(mySubstring)"
    }
    
    //MARK:- Get Day By Today, Tomorrow, Yesterday
    func getDayByTodayTomorrowYesterday(from interval : TimeInterval) -> String {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) { return "yesterday" }
        else if calendar.isDateInToday(date) { return "today" }
        else if calendar.isDateInTomorrow(date) { return "tomorrow" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(-day) days ago" }
            else { return "In \(day) days" }
        }
    }
    
    //MARK:- Type Casting Methods
    func isValueToInt(_ value: Any) -> Int {
        debugPrint(value)
        if let getValue = value as? Int {
            return getValue
        } else {
            if let getValue = value as? String {
                if !getValue.isBlank {
                    return Int(getValue)!
                } else {
                    return 0
                }
            }
        }
        return 0
    }
    
    func isValueToFloat(_ value: Any) -> Float {
        debugPrint(value)
        if let getValue = value as? Float {
            return getValue
        } else if let getValue = value as? Int {
            return Float(getValue)
        }else if let getValue = value as? Double {
            debugPrint("Float")
            return Float(getValue)
        } else {
            if let getValue = value as? String {
                if !getValue.isBlank {
                    return Float(getValue)!
                } else {
                    return 0
                }
            }
        }
        return 0
    }
    
    func isValueToString(_ value: Any) -> String {
        debugPrint(value)
        if let getValue = value as? Int {
            return "\(getValue)"
        } else {
            if let getValue = value as? String {
                return getValue
            } else if let getValue = value as? Float {
                return "\(getValue)"
            } else if let getValue = value as? Double {
                return "\(getValue)"
            }
        }
        return ""
    }
    
    //MARK: - Allow Numeric digits
    func allowNumbericDigits(_ str: String) -> Bool {
        //Only Allow Numeric digits
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = str.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return str == numberFiltered
    }
    
    
    func allowDigitsForAddFood(_ str: String) -> Bool {
        //Only Allow Numeric digits
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = str.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return str == numberFiltered
    }
    
    //MARK:- Detect Back Space
    func detectBackSpace(str: String) -> Bool{
        if let char = str.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        return false
    }
    
    //MARK:- Change ScollView Horizontal Indicator Color
    func changeScollVwIndicatorColor(_ scollVw: UIScrollView, color: UIColor) {
        if #available(iOS 13, *) {
            if scollVw.subviews.count > 0 && (scollVw.subviews[(scollVw.subviews.count - 1)].subviews.count > 0) {
                (scollVw.subviews[(scollVw.subviews.count - 1)].subviews[0]).backgroundColor = color
            }
        } else {
            if let verticalIndicator: UIImageView = (scollVw.subviews[(scollVw.subviews.count - 1)] as? UIImageView) {
                verticalIndicator.backgroundColor = color
            }
        }
    }
    
    //MARK:- Disable Copy & Paste functionality
    func disableCopyAndPasteWithWebVw(_ webVw: WKWebView) {
        let javascriptStyle = "var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}'; var head = document.head || document.getElementsByTagName('head')[0]; var style = document.createElement('style'); style.type = 'text/css'; style.appendChild(document.createTextNode(css)); head.appendChild(style);"
        webVw.evaluateJavaScript(javascriptStyle, completionHandler: nil)
    }
    
    //MARK:- Detect Current View Controller
    func detectCurrentController() -> UIViewController {
        if let window = UIApplication.shared.delegate?.window {
            if var viewController = window?.rootViewController {
                // handle navigation controllers
                if(viewController is UINavigationController){
                    viewController = (viewController as! UINavigationController).visibleViewController!
                }
                return viewController
            }
        }
        return UIViewController()
    }
    
    //MARK:- Register XIB On UITableView & Colectionview
    func registerXibOnTableView(_ identifier: String, tblVw: UITableView) {
        let nibName = UINib(nibName: identifier, bundle:nil)
        tblVw.register(nibName, forCellReuseIdentifier: identifier)
    }
    
    func registerXibOnCollectionViewView(_ identifier: String, collVw: UICollectionView) {
        let nibName = UINib(nibName: identifier, bundle:nil)
        collVw.register(nibName, forCellWithReuseIdentifier: identifier)
    }
    
    //MARK:- Get Number of days in Month
    func getNumberOfDaysInMonth(_ date: Date) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    //MARK:- CONVERT DATA TO JSON STRING METHOD
    func convertDataToJsonString(_ data: Data) {
        do {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let dict = json as NSDictionary
                debugPrint(Proxy.sharedInstance.convertDictionaryObjectToString(dict.mutableCopy() as! NSMutableDictionary))
            }
        }
    }
    
    //MARK:- SERVICE BOOKING DATE TIME METHOD
    func bookingDateTimeUsing(_ dateTimeStr: String) -> String {
        let bookingDate = dateFormatter.date(from: dateTimeStr)!
        dateFormatter.dateFormat = "EE"
        let strMonth = dateFormatter.string(from: bookingDate)
        dateFormatter.dateFormat = "dd"
        let strDate = dateFormatter.string(from: bookingDate)
        dateFormatter.dateFormat = "yyyy"
        let strYear = dateFormatter.string(from: bookingDate)
        dateFormatter.dateFormat = "HH:mm"
        let hoursMinutes = dateFormatter.string(from: bookingDate)
        return "\(strMonth) \(strDate), \(strYear) at \(hoursMinutes)"
    }
    
    //MARK:- GET UITABLEVIEW & UICOLLECTIONVIEW VISIBLE POINT
    func getTblVwVisiblePoint(_ tblVw: UITableView) -> CGPoint {
        var visibleRect = CGRect()
        visibleRect.origin = tblVw.contentOffset
        visibleRect.size = tblVw.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return visiblePoint
    }
    func getCollVwVisiblePoint(_ collVw: UICollectionView) -> CGPoint {
        var visibleRect = CGRect()
        visibleRect.origin = collVw.contentOffset
        visibleRect.size = collVw.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return visiblePoint
    }
    
    //MARK:- Convert Date object to local UTC Date object
    func convertDateObjToLocalDateObj(_ date: Date) -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: date))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: date) else {return Date()}
        return localDate
    }
    
    //MARK:- GET CURRENT UTC DATE TIME
    func getCurrentUtcDateTime() -> String {
        let utcDateFormatter = DateFormatter()
        utcDateFormatter.dateStyle = .long
        utcDateFormatter.timeStyle = .long
        
        //utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        utcDateFormatter.dateFormat = "MMM dd, yyyy 'at' HH:mm:ss a 'UTC'+5:30"
        //utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        // Printing a Date
        let date = Date()
        debugPrint(utcDateFormatter.string(from: date))
        return utcDateFormatter.string(from: date)
    }
    
    //MARK:- NAVIGATE ON GOOGLE MAP ON MARKER'S CLICK
    func navigateOnGoogleMapOnMarkerClick(_ latitude: String, longitude: String) {
        guard let latDouble =  Double(latitude) else {return }
        guard let longDouble =  Double(longitude) else {return }
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    
    //Show Hide Walk Throught Overlays
    
    func showWalkOverlay(_ view : UIView , _ label : UILabel , centerVal : CGFloat = 0 , tabBarHeight : Double = 0){
        view.isHidden = !AppCache.shared.isWalkThrough
        label.setLineSpacing(lineSpacing: 1.5,lineHeightMultiple: 1.5)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_walkPointer")
        imageView.frame = CGRect(x: centerVal + 10,
                                 y: UIScreen.main.bounds.maxY - 250,
                              width: 30,
                              height: 100)
        view.addSubview(imageView)

    }
 
    
    func hideWalkOverlay(_ view : UIView){
        AppCache.shared.isWalkThrough = false
        RootControllerProxy.shared.gotoHome()
    }
    
    
    
    var userToken: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppConstants.UserDefault.authToken)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: AppConstants.UserDefault.authToken)
        }
        
    }
}


