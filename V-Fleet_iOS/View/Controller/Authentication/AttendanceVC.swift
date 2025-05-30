//
//  AttendanceVC.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 19/07/24.
//

import UIKit
import DropDown
import CoreLocation

class AttendanceVC: UIViewController, AlertProtocol {

    @IBOutlet weak var vwStartShift: UIView!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblCurrentDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCheckIn: UIButton!
    @IBOutlet weak var btnShiftStart: UIButton!

    let dropDown = DropDown()
    let viewModel = AttendanceVM()
    let locationManager = LocationManager.shared
    var currentLatitude = CLLocationDegrees()
    var currentLongitude = CLLocationDegrees()
    var startLocation = ""
    var attendanceStatus = false
    var shiftStatus = false
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.font = AppFont.bold.fontWithSize(18)
        
   
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblName.text = "Namaste, \(UserAttandanceData.shared.driverName)"
        
        locationManager.checkLocationAuthorization { [weak self] (granted, status) in
            guard let self = self else { return }
            if granted {
                self.locationManager.startMonitoring()
                self.updateLocation()
            } else {
                print("Location access denied: \(String(describing: status))")
            }
        }
        lblCurrentDate.text = currentDate
        //lblCurrentTime.text = currentTime
        
        startTimer()
        //locationManager.stopMonitoring()
        //attendanceStatus = AppCache.shared.currentUser?.data?.attendanceStatus ?? false
        //shiftStatus = AppCache.shared.currentUser?.data?.shiftStatus ?? false
        
        if let attendanceStatus = UserDefaultsManager.shared.getValue(forKey: .attendance_Status) as? Bool {
            self.attendanceStatus = attendanceStatus
            print("attendanceStatus: \(attendanceStatus)")
        } else {
            print("attendanceStatus not found")
        }
        
        if let shiftStatus = UserDefaultsManager.shared.getValue(forKey: .shift_Status) as? Bool {
            self.shiftStatus = shiftStatus
            print("shiftStatus: \(shiftStatus)")
        } else {
            print("shiftStatus not found")
        }
        self.shiftStatus = AppCache.shared.currentUser?.data?.shiftStatus ?? false
        self.btnShiftStart.isSelected = AppCache.shared.currentUser?.data?.shiftStatus ?? false
        
        print("shiftattatus::",AppCache.shared.currentUser?.data?.shiftStatus ?? false)
        
        if attendanceStatus == true {
            btnCheckIn.isSelected = true
            vwStartShift.isHidden = false
        }else{
            btnCheckIn.isSelected = false
            vwStartShift.isHidden = true
        }
        
    }
    
    // Function to start the timer
       func startTimer() {
           timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
               self?.lblCurrentTime.text = self?.currentTime
           }
       }

    func updateAttendanceUI() {
        btnCheckIn.isSelected = attendanceStatus
    }

    func updateLocation() {
        if let location = locationManager.exposedLocation {
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
            
            print(currentLatitude, " >>>> ", currentLatitude)
            self.locationManager.stopMonitoring()
            
            locationManager.fetchCityAndCountry(from: location) { [weak self] (name, thoroughfare, subThorough, locality, subLocality, admin, subAdmin, country, postalCode, error) in
                
                
                if let error = error {
                    print("Error fetching city and country: \(error)")
                } else {
                    self?.startLocation = "\(name ?? ""),\(thoroughfare ?? ""), \(locality ?? ""), \(admin ?? ""), \(country ?? ""), \(postalCode ?? "")"
                }
            }
        }
    }

    @IBAction func actionMenuBtn(_ sender: UIButton) {
        dropDown.dataSource = ["Attendance History", "Logout"]
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            if index == 0 {
                self?.moveToNext(AttendanceHistoryVC.typeName, storyBoard: StoryBoard.main)
            } else {
                RootControllerProxy.shared.setRoot(LoginVC.typeName)
            }
        }
    }

    @IBAction func actionCheckIn(_ sender: UIButton) {
        guard let attendanceStatus = UserDefaultsManager.shared.getValue(forKey: .attendance_Status) as? Bool else { return }
        //        if attendanceStatus {
        //            attendanceStop()
        //            if let msg = viewModel.stopRequestModel.validationMsg {
        //                self.showAlert(title: "Warning", message: msg)
        //                return
        //            }
        //            stopAttendance()
        //        } else {
        //            setUpRequestModel()
        //            if let msg = viewModel.requestModel.validationMsg {
        //                self.showAlert(title: "Warning", message: msg)
        //                return
        //            }
        //            addSaveAttendance()
        //        }
        //        sender.isSelected = attendanceStatus
        
        if let attendanceStatus = UserDefaultsManager.shared.getValue(forKey: .attendance_Status) as? Bool {
            self.attendanceStatus = attendanceStatus
            print("attendanceStatus: \(attendanceStatus)")
        } else {
            print("attendanceStatus not found")
        }
        
        if let shiftStatus = UserDefaultsManager.shared.getValue(forKey: .shift_Status) as? Bool {
            self.shiftStatus = shiftStatus
            print("shiftStatus: \(shiftStatus)")
        } else {
            print("shiftStatus not found")
        }
        
        print("self.attendanceStatus", self.attendanceStatus)
        
        if self.attendanceStatus == false {
            setUpRequestModel()
            if let msg = viewModel.requestModel.validationMsg {
                self.showAlert(title: "Warning", message: msg)
                return
            }
            addSaveAttendance()
        }else{
            attendanceStop()
            if let msg = viewModel.stopRequestModel.validationMsg {
                self.showAlert(title: "Warning", message: msg)
                return
            }
            stopAttendance()
        }
        DispatchQueue.main.async {
            sender.isSelected = attendanceStatus
        }
        
        
    }

    @IBAction func actionShiftBtn(_ sender: UIButton) {
       // sender.isSelected.toggle()
        if !sender.isSelected {
            setUpRequestModel()
            if let msg = viewModel.requestModel.validationMsg {
                self.showAlert(title: "Warning", message: msg)
                return
            }
            startShift()
        } else {
            attendanceStop()
            if let msg = viewModel.stopRequestModel.validationMsg {
                self.showAlert(title: "Warning", message: msg)
                return
            }
            stopShift()
        }
    }

    func setUpRequestModel() {
        viewModel.requestModel = AttandanceRequestModel(
            driverId: UserAttandanceData.shared.driverID,
            vehicleId: UserAttandanceData.shared.vehicleId,
            startLatitude: currentLatitude,
            startLongitude: currentLongitude,
            startLocation: startLocation,
            superCompanyId: UserAttandanceData.shared.superCompanyID,
            companyId: UserAttandanceData.shared.companyID,
            vehicleNumber: UserAttandanceData.shared.vehicleNumber,
            driverName: UserAttandanceData.shared.driverName
        )
    }

    private func attendanceStop() {
        viewModel.stopRequestModel = AttandanceStopRequestModel(
            driverId: UserAttandanceData.shared.driverID,
            vehicleId: UserAttandanceData.shared.vehicleId,
            endLatitude: currentLatitude,
            endLongitude: currentLongitude,
            stopLocation: startLocation,
            superCompanyId: UserAttandanceData.shared.superCompanyID,
            companyId: UserAttandanceData.shared.companyID,
            vehicleNumber: UserAttandanceData.shared.vehicleNumber,
            driverName: UserAttandanceData.shared.driverName
        )
    }

    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy - EEEE"
        return dateFormatter.string(from: Date())
    }

    var currentTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a" // Including seconds
        return dateFormatter.string(from: Date())
    }
}

// MARK: - API METHODS
extension AttendanceVC {
    func addSaveAttendance() {
        CustomLoader.shared.show()
        viewModel.addSaveAttendance { [weak self] result in
            CustomLoader.shared.hide()
            
            switch result {
            case .success(let response):
                
                if let activeAttandance = self?.viewModel.responseModel?.data?.activeAttandance {
                    
                    UserDefaultsManager.shared.saveValue(activeAttandance, forKey: .attendance_Status)
                    self?.attendanceStatus = activeAttandance
                    //UserDefaultsManager.shared.saveValue(shiftStatus, forKey: .shift_Status)
                }
                
                self?.showAlertWithText(self?.viewModel.responseModel?.message ?? "") { _ in
                    
                    DispatchQueue.main.async {
                      
                        
                        if self?.viewModel.responseModel?.data?.activeAttandance == true {
                            self?.btnCheckIn.isSelected = true
                            self?.vwStartShift.isHidden = false
                        }else{
                            self?.btnCheckIn.isSelected = false
                            self?.vwStartShift.isHidden = true
                        }
                    }
                    
                }
            case .failure(let error):
                //self?.showAlert(title: AlertsNames.error.rawValue, message: error.message)
                self?.showAlert(title: AppConstants.appName, message: self?.viewModel.responseModel?.message ?? "")
            }
        }
    }

    func stopAttendance() {
        CustomLoader.shared.show()
        viewModel.stopAttendance { [weak self] result in
            CustomLoader.shared.hide()
            switch result {
            case .success:
                
                print("stopAttendance >>> ")
                self?.showAlertWithText(self?.viewModel.responseModel?.message ?? "") { _ in
                    
                    if self?.viewModel.responseModel?.status == 200 {
                        
                        DispatchQueue.main.async {
                            self?.btnCheckIn.isSelected = false
                            self?.vwStartShift.isHidden = true
                            self?.btnCheckIn.isSelected = false
                            
                            UserDefaultsManager.shared.saveValue(false, forKey: .attendance_Status)
                            self?.attendanceStatus = false
                            
                        }
                    }
                    
                
//                    if self?.viewModel.responseModel?.status == 500 {
//                        self?.showAlert(title: AppConstants.appName, message: self?.viewModel.responseModel?.message)
//                        return
//                       
//                    }
                    //self?.btnCheckIn.isSelected = false
                    
                    if self?.viewModel.responseModel?.data?.status == "Completed" {
                        self?.btnShiftStart.isSelected = true
                       
                    }else{
                        self?.btnShiftStart.isSelected = false
                    
                    }
                }
            case .failure(let error):
                self?.showAlert(title: AppConstants.appName, message: self?.viewModel.responseModel?.message)
            }
        }
    }

    func startShift() {
        CustomLoader.shared.show()
        viewModel.startShift { [weak self] result in
            CustomLoader.shared.hide()
            switch result {
            case .success(let response):
                let status = response.status
                if status == 200 {
                    DispatchQueue.main.async {
                        self?.btnShiftStart.isSelected = true
                    }
                }
                self?.showAlertWithText(self?.viewModel.responseModel?.message ?? "")
            case .failure(let error):
                self?.showAlert(title: AlertsNames.error.rawValue, message: error.message)
            }
        }
    }

    func stopShift() {
        CustomLoader.shared.show()
        viewModel.stopShift { [weak self] result in
            CustomLoader.shared.hide()
            switch result {
            case .success(let response):
                let status = response.status
                if status == 200 {
                    DispatchQueue.main.async {
                        self?.btnShiftStart.isSelected = false
                    }
                }
                self?.showAlertWithText(self?.viewModel.responseModel?.message ?? "")
            case .failure(let error):
                self?.showAlert(title: AlertsNames.error.rawValue, message: error.message)
            }
        }
    }
}
