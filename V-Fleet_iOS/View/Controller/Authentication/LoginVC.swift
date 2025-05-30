//
//  LoginVC.swift
//  PocketITNerd
//
//  Created by ashish mehta on 11/10/22.
//
import UIKit
import IQKeyboardManagerSwift
import Alamofire

class UserAttandanceData {
    static let shared = UserAttandanceData()
    var driverID: Int = 0
    var superCompanyID: Int = 0
    var companyID: Int = 0
    var vehicleNumber: String = ""
    var vehicleId : Int = 0
    var driverName : String = ""
    var userId : Int = 0
    var role : String = ""
    //var superCompanyId : Int = 0
    private init() {} // This prevents others from using the default '()' initializer for this class.
}

class LoginVC: UIViewController, AlertProtocol {

    @IBOutlet var txtFldPhone: UITextField!
    @IBOutlet weak var vwLogin: UIView!
    let viewModel = LoginVM()
    let dbHelper = DatabaseHelper.shared

    override func viewDidLoad() {
        super.viewDidLoad()
   /// txtFldPhone.text = "7044692859"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allUserDetailsApiCall()
        getAllVehicleDetails()
        getFuelInfoForOfflineSyncForAllVehicles()
        creatingDBTable()
          
    }
    
    func allUserDetailsApiCall() {
        if let networkManager = NetworkReachabilityManager(), networkManager.isReachable {
            print("Internet is available")
            viewModel.getAllUsersData { [weak self] result in
                guard let self = self else { return }
                
                // Hide loader once API call is completed
                CustomLoader.shared.hide()
                
                switch result {
                case .success(let response):
                    // Handle specific status codes and show corresponding alerts
                    
                    if [500, 401, 404].contains(response.status) {
                        self.showAlert(title: AppConstants.appName, message: self.viewModel.responseModel?.message)
                        return
                    }
                    
                    // Ensure response data exists
                    guard let data = self.viewModel.userDataResponseModel?.data else {
                        self.showAlert(title: AppConstants.appName, message: "Unexpected error: No data received.")
                        return
                    }
                    
                case .failure(let error):
                    // Handle failure and show an alert
                    self.showAlert(title: AppConstants.appName, message: error.message)
                }
            }
        } else {
            print("No internet connection")
            self.showAlert(title: AppConstants.appName, message: "Internet connection is not available.")
        }

    }
    
    func creatingDBTable(){
        dbHelper.createUsersTable()
        dbHelper.createVehiclesTable()
        dbHelper.createFuelInfoTable()
    }
    
    func setUpRequestModel() {
        viewModel.requestModel = LoginRequestModel(mobile: self.txtFldPhone.text ?? "")
    }

    @IBAction func actionLogin(_ sender: Any) {
//        if let networkManager = NetworkReachabilityManager(), networkManager.isReachable {
//            
//        }
        
        if let networkManager = NetworkReachabilityManager(), networkManager.isReachable {
            setUpRequestModel()
            if let msg = viewModel.requestModel.validationMsg {
                self.showAlert(title: AppConstants.appName, message: msg)
                return
            }
            self.hitLoginApi()
        } else if let textFieldPhone = self.txtFldPhone.text {
            let mobileNumbers = dbHelper.getAllUserMobileNumbers()
            if mobileNumbers.contains(textFieldPhone) {
                self.moveToNext(ScanQRCodeVC.typeName)
            }
        } else {
            self.showAlert(title: AppConstants.appName, message: "User not found.")
        }
        
//        setUpRequestModel()
//        if let msg = viewModel.requestModel.validationMsg {
//            self.showAlert(title: AppConstants.appName, message: msg)
//            return
//        }
//        self.hitLoginApi()
        //self.moveToNext(ScanQRCodeVC.typeName)
    }
}
//MARK: - API METHODS
extension LoginVC {
    //    func hitLoginApi() {
    //        CustomLoader.shared.show()
    //        viewModel.login { [weak self] (result) in
    //            CustomLoader.shared.hide()
    //            switch result {
    //            case .success(let response):
    //
    //                if response.status == 500 {
    //                    self?.showAlert(title: AppConstants.appName, message: response.message)
    //                    return
    //                }
    //
    //
    //                print("sucess1::",response)
    //                // MARK: - get data
    //                print("DriverId :: ", self?.viewModel.responseModel?.data?.driverID ?? "")
    //                print("SuperCompeny :: ", self?.viewModel.responseModel?.data?.superCompanyID ?? "")
    //                print("CompenyId :: ", self?.viewModel.responseModel?.data?.companyID ?? "")
    //                print("DriverName :: ", self?.viewModel.responseModel?.data?.name ?? "")
    //
    //                UserAttandanceData.shared.driverID = self?.viewModel.responseModel?.data?.driverID ?? 0
    //                UserAttandanceData.shared.superCompanyID = self?.viewModel.responseModel?.data?.superCompanyID ?? 0
    //                UserAttandanceData.shared.driverName = self?.viewModel.responseModel?.data?.name ?? ""
    //                UserAttandanceData.shared.userId = self?.viewModel.responseModel?.data?.id ?? 0
    //                UserAttandanceData.shared.companyID = self?.viewModel.responseModel?.data?.companyID ?? 0
    //                print("response12::",response.status)
    //
    //                self?.moveToNext(ScanQRCodeVC.typeName)
    //
    //            case .failure(let error):
    //                self?.showAlert(title: AppConstants.appName, message: error.message)
    //            }
    //        }
    //    }
    
//    func hitLoginApi() {
//        CustomLoader.shared.show()
//        
//        viewModel.login { [weak self] (result) in
//            // Ensure self is still in memory
//            guard let self = self else { return }
//            
//            // Hide loader regardless of the outcome
//            CustomLoader.shared.hide()
//            
//            switch result {
//            case .success(let response):
//                // Handle the status 500 case
//                
//                print("response message::",response.message)
//                print("response status::",response.status)
//
//                
//                if response.status == 500 {
//                    self.showAlert(title: AppConstants.appName, message: self.viewModel.responseModel?.message)
//                    return
//                }
//                
//                if response.status == 401 {
//                    self.showAlert(title: AppConstants.appName, message: self.viewModel.responseModel?.message)
//                    return
//                }
//                if response.status == 404 {
//                    self.showAlert(title: AppConstants.appName, message: self.viewModel.responseModel?.message)
//                    return
//                }
////
//                
//                // Ensure response data is available
//                guard let data = self.viewModel.responseModel?.data else {
//                    self.showAlert(title: AppConstants.appName, message: "Unexpected error: No data received.")
//                    return
//                }
//                
//                // MARK: - Get data and update shared UserAttandanceData
//                print("Success:", response)
//                print("DriverId:", data.driverID ?? 0)
//                print("SuperCompany:", data.superCompanyID ?? 0)
//                print("CompanyId:", data.companyID ?? 0)
//                print("DriverName:", data.name ?? 0)
//                
//                UserAttandanceData.shared.driverID = data.driverID ?? 0
//                UserAttandanceData.shared.superCompanyID = data.superCompanyID ?? 0
//                UserAttandanceData.shared.driverName = data.name ?? ""
//                UserAttandanceData.shared.userId = data.id ?? 0
//                UserAttandanceData.shared.companyID = data.companyID ?? 0
//                
//                print("Response Status:", response.status)
//                
//                // Move to the next view controller
//                self.moveToNext(ScanQRCodeVC.typeName)
//                
//            case .failure(let error):
//                // Show alert in case of failure
//                self.showAlert(title: AppConstants.appName, message: error.message)
//            }
//        }
//    }
    
    
    func hitLoginApi() {
        CustomLoader.shared.show()
        
        viewModel.login { [weak self] result in
            guard let self = self else { return }
            
            // Hide loader once API call is completed
            CustomLoader.shared.hide()
            
            switch result {
            case .success(let response):
                // Handle specific status codes and show corresponding alerts
                
                
                if [500, 401, 404].contains(response.status) {
                    self.showAlert(title: AppConstants.appName, message: self.viewModel.responseModel?.message)
                    return
                }
                
                // Ensure response data exists
                guard let data = self.viewModel.responseModel?.data else {
                    self.showAlert(title: AppConstants.appName, message: "Unexpected error: No data received.")
                    return
                }
                
                // Update shared UserAttandanceData
                print("name: ",data.name ?? "" )
                print("superCompanyID: ",data.superCompanyID ?? "" )
                UserAttandanceData.shared.driverID = data.driverID ?? 0
                UserAttandanceData.shared.superCompanyID = data.superCompanyID ?? 0
                UserAttandanceData.shared.driverName = data.name ?? ""
                UserAttandanceData.shared.userId = data.id ?? 0
                UserAttandanceData.shared.companyID = data.companyID ?? 0
                
//
                // Navigate to the next screen
                self.moveToNext(ScanQRCodeVC.typeName)
            
            case .failure(let error):
                // Handle failure and show an alert
                self.showAlert(title: AppConstants.appName, message: error.message)
            }
        }
    }

}

extension LoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtFldPhone {
            if string.contains(" ") {
                return false
            }
        }
        return true
    }
}


extension LoginVC {
    func getAllVehicleDetails() {
        CustomLoader.shared.show()
        viewModel.getAllVehicleDetails() { [weak self] (result) in
            CustomLoader.shared.hide()
            switch result {
            case .success(let response):
                print("getAllVehicleDetails sucess")
          
            case .failure(let error):
                self?.showAlert(title: AlertsNames.error.rawValue, message: error.message)
            }
        }
    }
    
    func getFuelInfoForOfflineSyncForAllVehicles() {
        CustomLoader.shared.show()
        viewModel.getFuelInfoForOfflineSyncForAllVehicles() { [weak self] (result) in
            CustomLoader.shared.hide()
            switch result {
            case .success(_):
                print("getFuelInfoForOfflineSyncForAllVehicles sucess")
          
            case .failure(let error):
                self?.showAlert(title: AlertsNames.error.rawValue, message: error.message)
            }
        }
    }
}

