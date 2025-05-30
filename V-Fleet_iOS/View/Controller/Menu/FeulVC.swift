//
//  FeulVC.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 19/07/24.
//

import UIKit
import DropDown
import CoreLocation

class FeulVC: UIViewController, AlertProtocol {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVehicleNumber: UILabel!
    @IBOutlet weak var txtFildQuentity: UITextField!
    @IBOutlet weak var txtFildCurrentOdometer: UITextField!
    @IBOutlet weak var txtFldChooseFile: UITextField!
    
    
    let dropDown = DropDown()
    let viewModel = FeulVM()
    var diffOdoValue: Double = 0.0
    var mileage: Double = 0.0
    let locationManager = LocationManager.shared
    var currentLatitude = CLLocationDegrees()
    var currentLongitude = CLLocationDegrees()
    var startLocation = ""
    var currentOdometer: Int = 0
    var quentity : Int = 0
    var averageMileage : Double = 0.0
    var prevQuantityFilled : Double = 0
    var totalKm : Double = 0.0
    var previousOdometer : Double = 0.0
    var remainFuel : Double = 0.0
    var totalUnusedFuel : Double = 0.0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = "Namaste, \(UserAttandanceData.shared.driverName)"
        lblVehicleNumber.text = UserAttandanceData.shared.vehicleNumber
        print("driverName::", UserAttandanceData.shared.driverName)
        print("vehicleNumber::", UserAttandanceData.shared.vehicleNumber)
        lblName.font = AppFont.bold.fontWithSize(18)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.txtFildQuentity.text = ""
        super.viewWillAppear(animated)
        
        locationManager.checkLocationAuthorization { [weak self] (granted, status) in
            guard let self = self else { return }
            if granted {
                self.locationManager.startMonitoring()
                self.updateLocation()
            } else {
                print("Location access denied: \(String(describing: status))")
            }
        }
        getVehicleInfoAtRefueling(date: currentDate, time: currentTime, vehicleId: UserAttandanceData.shared.vehicleId)
    }
    
    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    var currentTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" // Use 24-hour format
        let timeString = dateFormatter.string(from: Date())
        
        // URL-encode the time string
        let allowedCharacterSet = CharacterSet(charactersIn: ":").inverted
        let encodedTimeString = timeString.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? timeString
        
        return encodedTimeString
    }
    
//    func setUpRequestModel() {
//        // Guard statements to ensure valid input for current odometer and fuel quantity
//        guard let currentOdometerText = self.txtFildCurrentOdometer.text,
//              let currentOdometer = Double(currentOdometerText),
//              let quantityText = self.txtFildQuentity.text,
//              let quantity = Double(quantityText) else {
//            debugPrint("Invalid input for current odometer or fuel quantity")
//            return
//        }
//        
//        // Calculate difference between current and previous odometer readings
//        self.diffOdoValue = currentOdometer - self.previousOdometer
//        print("Difference (trip)::", self.diffOdoValue)
//        
//        // Check if the difference in odometer reading is less than 50
//        if self.diffOdoValue < 50 {
//            // Case: Previous quantity filled is greater than 15
//            if self.prevQuantityFilled > 15 {
//                print("Trip < 50 && Previous Quantity > 15")
//                print("remaining fuel ==>>", self.remainFuel)
//                // If remaining fuel is 0, calculate totalKm and mileage
//                if self.remainFuel == 0 {
//                    print("Fuel remaining is 0")
//                    self.totalKm = self.prevQuantityFilled * self.averageMileage
//                    print("Total Km  === 0:::", self.totalKm)
//                    
//                    self.remainFuel = (self.totalKm - Double(self.diffOdoValue)) / self.averageMileage
//                    print("Remaining Fuel === 0::", self.remainFuel)
//                    
//                    self.mileage = Double(self.diffOdoValue) / (self.prevQuantityFilled - self.remainFuel)
//                    print("Mileage ==== 0::>>", self.mileage)
//                } else {
//                    // If remaining fuel is not 0, use total unused fuel for calculation
//                    self.totalKm = self.totalUnusedFuel * self.averageMileage
//                    print("Total Km::------>>", self.totalKm)
//                    
//                    self.remainFuel = (self.totalKm - Double(self.diffOdoValue)) / self.averageMileage
//                    print("Calculated Remaining Fuel----::>>", self.remainFuel)
//                    
//                    self.mileage = Double(self.diffOdoValue) / (self.totalUnusedFuel - self.remainFuel)
//                    print("Mileage-----::>>", self.mileage)
//                }
//            }  else if self.prevQuantityFilled < 5 {
//                self.totalKm = self.totalUnusedFuel * self.averageMileage
//                print("Total Km  < 5::>>", self.totalKm)
//                
//                self.remainFuel = (self.totalKm - Double(self.diffOdoValue)) / self.averageMileage
//                print("Calculated Remaining Fuel < 5::>>", self.remainFuel)
//                
//                self.mileage = Double(self.diffOdoValue) / (self.totalUnusedFuel - self.remainFuel)
//                print("Mileage < 5 ::>>", self.mileage)
//            }
//            
//        }else if self.remainFuel > 0 {
//            self.mileage = Double(self.diffOdoValue) / self.totalUnusedFuel
//            print("Mileage > 0::>>", self.mileage)
//            self.remainFuel = 0
//        }else {
//            // Fallback case: Use previous quantity filled for mileage calculation
//            self.mileage = Double(self.diffOdoValue) / self.prevQuantityFilled
//            print("Mileage: \(self.mileage)")
//        }
//        
//        // Prepare the request model on the main thread
//        self.viewModel.postFuelDetailsRequestModel = PostFuelDetailsRequestModel(
//            vehicleId: UserAttandanceData.shared.vehicleId,
//            odoValue: currentOdometer,
//            prevOdoValue: self.previousOdometer,
//            diffOdoValue: self.diffOdoValue,
//            quantity: quantity,
//            mileage: self.mileage,
//            prevMileage: self.averageMileage,
//            superCompanyId: UserAttandanceData.shared.superCompanyID,
//            companyId: UserAttandanceData.shared.companyID,
//            location: self.startLocation,
//            odometerImage: self.viewModel.upload,
//            fuelRemain: self.remainFuel
//        )
//    }
    
    func setUpRequestModel() {
        // Check if prevOdoValue is 0, show an alert if it is
//        if self.prevQuantityFilled == 0 {
////            let alert = UIAlertController(title: "Please wait..", message: "First entry will be made from the web or by admin", preferredStyle: .alert)
////            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
////            self.present(alert, animated: true, completion: nil)
//            self.showAlert(title: AppConstants.appName, message: "First entry will be made from the web or by admin") { _ in
//                self.txtFildQuentity.text = ""
//                self.txtFildCurrentOdometer.text = ""
//                self.txtFldChooseFile.text = ""
//            }
//            return
//        }
        
        // Guard statements to ensure valid input for current odometer and fuel quantity
        guard let currentOdometerText = self.txtFildCurrentOdometer.text,
              let currentOdometer = Double(currentOdometerText),
              let quantityText = self.txtFildQuentity.text,
              let quantity = Double(quantityText) else {
            debugPrint("Invalid input for current odometer or fuel quantity")
            return
        }
        
        // Calculate difference between current and previous odometer readings
        self.diffOdoValue = currentOdometer - self.previousOdometer
        print("Difference (trip)::", self.diffOdoValue)
        
        // Check if the difference in odometer reading is less than 50
        if self.diffOdoValue < 50 {
            // Case: Previous quantity filled is greater than 15
            if self.prevQuantityFilled > 15 {
                print("Trip < 50 && Previous Quantity > 15")
                print("remaining fuel ==>>", self.remainFuel)
                
                // If remaining fuel is 0, calculate totalKm and mileage
                if self.remainFuel == 0 {
                    print("Fuel remaining is 0")
                    self.totalKm = self.prevQuantityFilled * self.averageMileage
                    print("Total Km  === 0:::", self.totalKm)
                    
                    self.remainFuel = (self.totalKm - Double(self.diffOdoValue)) / self.averageMileage
                    print("Remaining Fuel === 0::", self.remainFuel)
                    
                    self.mileage = Double(self.diffOdoValue) / (self.prevQuantityFilled - self.remainFuel)
                    print("Mileage ==== 0::>>", self.mileage)
                } else {
                    // If remaining fuel is not 0, use total unused fuel for calculation
                    self.totalKm = self.totalUnusedFuel * self.averageMileage
                    print("Total Km::------>>", self.totalKm)
                    
                    self.remainFuel = (self.totalKm - Double(self.diffOdoValue)) / self.averageMileage
                    print("Calculated Remaining Fuel----::>>", self.remainFuel)
                    
                    self.mileage = Double(self.diffOdoValue) / (self.totalUnusedFuel - self.remainFuel)
                    print("Mileage-----::>>", self.mileage)
                }
            } else if self.prevQuantityFilled < 5 {
                self.totalKm = self.totalUnusedFuel * self.averageMileage
                print("Total Km  < 5::>>", self.totalKm)
                
                self.remainFuel = (self.totalKm - Double(self.diffOdoValue)) / self.averageMileage
                print("Calculated Remaining Fuel < 5::>>", self.remainFuel)
                
                self.mileage = Double(self.diffOdoValue) / (self.totalUnusedFuel - self.remainFuel)
                print("Mileage < 5 ::>>", self.mileage)
            }
            
        } else if self.remainFuel > 0 {
            self.mileage = Double(self.diffOdoValue) / self.totalUnusedFuel
            print("Mileage > 0::>>", self.mileage)
            self.remainFuel = 0
        } else {
            // Fallback case: Use previous quantity filled for mileage calculation
            self.mileage = Double(self.diffOdoValue) / self.prevQuantityFilled
            print("Mileage: \(self.mileage)")
        }
        
        // Prepare the request model on the main thread
        self.viewModel.postFuelDetailsRequestModel = PostFuelDetailsRequestModel(
            vehicleId: UserAttandanceData.shared.vehicleId,
            odoValue: currentOdometer,
            prevOdoValue: self.previousOdometer,
            diffOdoValue: self.diffOdoValue,
            quantity: quantity,
            mileage: self.mileage,
            prevMileage: self.averageMileage,
            superCompanyId: UserAttandanceData.shared.superCompanyID,
            companyId: UserAttandanceData.shared.companyID,
            location: self.startLocation,
            odometerImage: self.viewModel.upload,
            fuelRemain: self.remainFuel
        )
    }


    @IBAction func actionBrowser(_ sender: Any) {
        MediaPicker.shared.setupPicker(delegate: self, allowVideoSelectionOnly: false)
        MediaPicker.shared.openActionSheetForImagePicker()
    }
    
    @IBAction func actionMenuBtn(_ sender: UIButton) {
        var menuItems = ["Logout"]
        // Removed the condition for adding "Attendance History"
        dropDown.dataSource = menuItems
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            if item == "Logout" {
                RootControllerProxy.shared.setRoot(LoginVC.typeName)
            }
        }
    }
    
    
//    @IBAction func actionSubmit(_ sender: Any) {
//        
//        guard let permission = checkPermissionBeforeClickSubnitBtn() else {
//            print("permition is not given.")
//            return
//        }
//        
//        
//        if permission {
//            let trimmedQuantityText = txtFildQuentity.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            let trimmedCurrentOdometerText = txtFildCurrentOdometer.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            let trimmedFilePath = txtFldChooseFile.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            if let quantityText = trimmedQuantityText, quantityText.isEmpty {
//                self.showAlert(title: AppConstants.appName, message: "Quantity field cannot be empty")
//                return
//            } else if let quantityValue = Int(trimmedQuantityText ?? ""), quantityValue <= 0 {
//                self.showAlert(title: AppConstants.appName, message: "Please enter a valid quantity") { _ in
//                    self.txtFildQuentity.text = ""
//                }
//                return
//            }
//            guard let currentOdometerText = trimmedCurrentOdometerText, !currentOdometerText.isEmpty, let currentOdometerValue = Double(currentOdometerText) else {
//                self.showAlert(title: AppConstants.appName, message: "Odometer field cannot be empty or invalid") { _ in
//                    self.txtFildCurrentOdometer.text = ""
//                }
//                return
//            }
//            if currentOdometerValue == 0 {
//                self.showAlert(title: AppConstants.appName, message: "Odometer value cannot be zero") { _ in
//                    self.txtFildCurrentOdometer.text = ""
//                }
//                return
//            }
//                 if let filePath = trimmedFilePath, filePath.isEmpty {
//                     self.showAlert(title: AppConstants.appName, message: "Please choose a file to upload") { _ in
//                         self.txtFldChooseFile.text = ""
//                     }
//                     return
//                 }
//            if let msg = viewModel.postFuelDetailsRequestModel.validationMsg {
//                self.showAlert(title: AppConstants.appName, message: msg)
//                return
//            }
//            if let quantityValue = Double(self.txtFildQuentity.text ?? "") {
//                self.getPrevMileage(vehicleId: UserAttandanceData.shared.vehicleId, currentMileage: self.mileage)
//            } else {
//                self.showAlert(title: AppConstants.appName, message: "Invalid mileage value")
//            }
//        }
//    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        guard let permission = checkPermissionBeforeClickSubnitBtn() else {
            print("Permission is not given.")
            return
        }
        
        if permission {
            let trimmedQuantityText = txtFildQuentity.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedCurrentOdometerText = txtFildCurrentOdometer.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedFilePath = txtFldChooseFile.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Check if quantity field is empty
            if let quantityText = trimmedQuantityText, quantityText.isEmpty {
                self.showAlert(title: AppConstants.appName, message: "Quantity field cannot be empty")
                return
            } else if let quantityValue = Int(trimmedQuantityText ?? ""), quantityValue <= 0 {
                self.showAlert(title: AppConstants.appName, message: "Please enter a valid quantity") { _ in
                    self.txtFildQuentity.text = ""
                }
                return
            }
            
            // Check if odometer field is empty or invalid
            guard let currentOdometerText = trimmedCurrentOdometerText, !currentOdometerText.isEmpty, let currentOdometerValue = Double(currentOdometerText) else {
                self.showAlert(title: AppConstants.appName, message: "Odometer field cannot be empty or invalid") { _ in
                    self.txtFildCurrentOdometer.text = ""
                }
                return
            }
            
            if currentOdometerValue == 0 {
                self.showAlert(title: AppConstants.appName, message: "Odometer value cannot be zero") { _ in
                    self.txtFildCurrentOdometer.text = ""
                }
                return
            }
            
            // Check if file selection is required for the role "DRIVE"
            if UserAttandanceData.shared.role == "DRIVER", let filePath = trimmedFilePath, filePath.isEmpty {
                self.showAlert(title: AppConstants.appName, message: "Please choose a file to upload") { _ in
                    self.txtFldChooseFile.text = ""
                }
                return
            }
            
            // Validation message check
            if let msg = viewModel.postFuelDetailsRequestModel.validationMsg {
                self.showAlert(title: AppConstants.appName, message: msg)
                return
            }
            
            // Check mileage
            if Double(self.txtFildQuentity.text ?? "") != nil {
                self.getPrevMileage(vehicleId: UserAttandanceData.shared.vehicleId, currentMileage: self.mileage)
            } else {
                self.showAlert(title: AppConstants.appName, message: "Invalid mileage value")
            }
        }
    }

    @IBAction func backButtonAciton(_ sender: UIButton) {
        popToBack()
    }
    
    
    func checkPermissionBeforeClickSubnitBtn() -> Bool? {
        var isGivenLocationPermission = false
        locationManager.checkLocationAuthorization { [weak self] (granted, status) in
            guard let self = self else { return }
            if granted {
                self.locationManager.startMonitoring()
                self.updateLocation()
                isGivenLocationPermission = true
            } else {
                print("Location access denied: \(String(describing: status))")
                locationManager.showLocationPermissionAlert()
                isGivenLocationPermission = false
            }
        }
        return isGivenLocationPermission
    }
    
    func updateLocation() {
        if let location = locationManager.exposedLocation {
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
            
            print("currentLatitude:::>>>> ", currentLatitude)
            print("Current Latitude: \(currentLatitude), Current Longitude: \(currentLongitude)")
            self.locationManager.stopMonitoring()
            locationManager.fetchCityAndCountry(from: location) { [weak self] (name, thoroughfare, subThorough, locality, subLocality, admin, subAdmin, country, postalCode, error) in
                if let error = error {
                    print("Error fetching city and country: \(error)")
                } else {
                    
                    self?.startLocation = "\(name ?? ""),\(thoroughfare ?? ""), \(locality ?? ""), \(admin ?? ""), \(country ?? ""), \(postalCode ?? "")"
                    print("startLocation:::",self?.startLocation ?? "")
                }
            }
        }
    }
}

// MARK: - MediaPickerDelegate
extension FeulVC: MediaPickerDelegate {
    func mediaPicker(_ mediaPicker: MediaPicker, didChooseImage image: UIImage?, imageName: String?) {
        print("imageName:::>>>",imageName ?? "")
        print("Image:::>>>",image ?? "")
        viewModel.requestupladFile.file = image?.jpegData(compressionQuality: 0.2)
        uploadImgApi()
    }
}


// MARK: - API METHODS
extension FeulVC {
    func getVehicleInfoAtRefueling(date: String, time: String, vehicleId: Int) {
        CustomLoader.shared.show()
        viewModel.getVehicleInfoAtRefueling(vehicleId: vehicleId) { [weak self] result in
            CustomLoader.shared.hide()
            switch result {
            case .success(let response):
                if response.status == 404 {
                    self?.showAlert(title: AppConstants.appName, message: self?.viewModel.getLastVehicleInfoAtRefuelingRequestModel?.message )
                }
                DispatchQueue.main.async {
                    self?.prevQuantityFilled = self?.viewModel.getLastVehicleInfoAtRefuelingRequestModel?.data?.prevQuantityFilled ?? 0.0
                    self?.averageMileage = self?.viewModel.getLastVehicleInfoAtRefuelingRequestModel?.data?.averageMileage ?? 0.0
                    self?.previousOdometer = self?.viewModel.getLastVehicleInfoAtRefuelingRequestModel?.data?.previousOdometer ?? 0.0
                    self?.remainFuel = self?.viewModel.getLastVehicleInfoAtRefuelingRequestModel?.data?.remainFuel ?? 0.0
                    self?.totalUnusedFuel = self?.viewModel.getLastVehicleInfoAtRefuelingRequestModel?.data?.totalUnusedFuel ?? 0.0
                    print("averageMileage::",self?.averageMileage ?? 0)
                    print("prevQuantityFilled::",self?.prevQuantityFilled ?? 0)
                    print("previousOdometer::",self?.previousOdometer ?? 0)
                    print("remainFuel::",self?.remainFuel ?? 0)
                    print("totalUnusedFuel::",self?.totalUnusedFuel ?? 0)
                }
            case .failure(let error):
                self?.showAlert(title: AlertsNames.v_Fuel.rawValue, message: error.message)
            }
        }
    }
    
    // New method to get previous mileage
    func getPrevMileage(vehicleId: Int, currentMileage: Double) {
        CustomLoader.shared.show()
        viewModel.getPrevMileage(vehicleId: vehicleId, currentMileage: Double(currentMileage)) { [weak self] result in
            CustomLoader.shared.hide()
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("averageMileage1:::",self?.viewModel.prevMileageResponseModel?.data?.averageMileage ?? 0.0)
                    self?.averageMileage = self?.viewModel.prevMileageResponseModel?.data?.averageMileage ?? 0.0
                    if self?.prevQuantityFilled != 0 {
                        self?.postFuelDetails(userId: "\(UserAttandanceData.shared.userId)")
                    }else {
                        self?.showAlert(title: AppConstants.appName, message: "First entry will be made from the web or by admin") { _ in
                            self?.txtFildQuentity.text = ""
                            self?.txtFildCurrentOdometer.text = ""
                            self?.txtFldChooseFile.text = ""
                            self?.txtFildQuentity.resignFirstResponder()
                        }
                    }
                }
            case .failure(let error):
                self?.showAlert(title: AlertsNames.v_Fuel.rawValue, message: error.message)
            }
        }
    }
    
    func postFuelDetails(userId: String) {
        CustomLoader.shared.show()
        self.setUpRequestModel()
        viewModel.postFuelDetails(userId: userId) { [weak self] result in
            CustomLoader.shared.hide()
            switch result {
            case .success(let response):
                print("success")
                
                DispatchQueue.main.async {
                    self?.showAlert(title: AppConstants.appName, message: self?.viewModel.postFuelDetailsResponseModel?.message) { _ in
                        self?.txtFildQuentity.text = ""
                        self?.txtFildCurrentOdometer.text = ""
                        self?.txtFldChooseFile.text = ""
                        self?.getVehicleInfoAtRefueling(date: self?.currentDate ?? "", time: self?.currentTime ?? "", vehicleId: UserAttandanceData.shared.vehicleId)
                    }
                }
                // self?.showAlert(title: AlertsNames.error.rawValue, message: self?.viewModel.postFuelDetailsResponseModel?.message)
                print("response::", response)
            case .failure(let error):
                self?.showAlert(title: AlertsNames.v_Fuel.rawValue, message: error.message)
            }
        }
    }
    func uploadImgApi() {
        CustomLoader.shared.show()
        viewModel.uplaodImage { (result) in
            CustomLoader.shared.hide()
            switch result {
            case .success(_):
                print("***Success***")
                DispatchQueue.main.async {
                    self.txtFldChooseFile.text = self.viewModel.upload//imageName
                    print("upload image::",self.viewModel.upload)
                }
            case .failure(let errorBlock):
                self.showAlertWithText(errorBlock.message)
            }
        }
    }
}

extension FeulVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFildCurrentOdometer {
            if string.contains(" ") {
                return false
            }
        }
        if textField == txtFildQuentity {
            if string.contains(" ") {
                return false
            }
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == txtFildCurrentOdometer {
            if let currentOdometerText = txtFildCurrentOdometer?.text,
               let currentOdometerValue = Double(currentOdometerText) {
                self.currentOdometer = Int(currentOdometerValue)
                
            } else {
                self.currentOdometer = Int(0.0)
            }
            return true
        } else if textField == txtFildQuentity {
            if let quantityText = txtFildQuentity?.text,
               let quantityValue = Double(quantityText) {
                self.quentity = Int(quantityValue)
            }
            return true
        }
        return true
    }
}



