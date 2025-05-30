//
//  ExpanceVC.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 19/07/24.
//

import UIKit
import DropDown
import SDWebImage

class ExpanceVC: UIViewController,AlertProtocol {
    
    @IBOutlet weak var vwUploadFile: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var btnImg: UIButton!
    @IBOutlet weak var txtFldAmount: UITextField!
    let dropDown = DropDown()
    let viewModel = ExpanceVM()
    var objUploadImgRequestModel = UploadImgRequestModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDottedBorder(to: vwUploadFile)
        lblName.text = "Namaste, \(UserAttandanceData.shared.driverName)"
        lblName.font = AppFont.bold.fontWithSize(18)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtFldAmount.text = ""
    }
    
    @IBAction func actionMenuBtn(_ sender: UIButton) {
        dropDown.dataSource = ["Logout"]//4
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            // sender.setTitle(item, for: .normal) //9
            // self?.lblProductPrice.text = item
            if index == 0 {
               // self?.moveToNext(AttendanceVC.typeName, storyBoard: StoryBoard.main)
                RootControllerProxy.shared.setRoot(LoginVC.typeName)
            }
        }
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        //        setRequestModelValues()
        //        if let message = viewModel.requestModel.validationMessage(){
        //            self.showAlert(title: AppConstants.appName, message: message)
        //        }else{
        //            addEditProfileData()
        //        }
        
//        setRequestModelValues()
//        
//        // Check if txtFldAmount is empty or less than or equal to 0
//        if let amountText = txtFldAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines), !amountText.isEmpty {
//            if let amount = Double(amountText), amount > 0 {
//                // If amount is valid, continue with validation message check
//                if let message = viewModel.requestModel.validationMessage() {
//                    self.showAlert(title: AppConstants.appName, message: message)
//                } else {
//                    addEditProfileData()
//                }
//            } else {
//                // Show alert if the amount is less than or equal to 0
//                self.showAlert(title: AppConstants.appName, message: "Please enter a valid amount greater than 0.")
//            }
//        } else {
//            // Show alert if the amount is empty
//            self.showAlert(title: AppConstants.appName, message: "Please enter the amount.")
//        }
        
        
        setRequestModelValues()
           
           // Check if txtFldAmount is empty or less than or equal to 0
           if let amountText = txtFldAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines), !amountText.isEmpty {
               if let amount = Double(amountText), amount > 0 {
                   // Check if imageVw has an image
                   if imageVw.image != nil {
                       // Proceed with the upload or other actions
                       addEditProfileData()
                   } else {
                       // Show alert if no image is selected
                       self.showAlert(title: AppConstants.appName, message: "Upload expense Document.")
                   }
               } else {
                   // Show alert if the amount is less than or equal to 0
                   self.showAlert(title: AppConstants.appName, message: "Please enter a valid amount greater than 0.")
               }
           } else {
               // Show alert if the amount is empty
               self.showAlert(title: AppConstants.appName, message: "Please enter the amount.")
           }
    }
    
    @IBAction func actionImagebtn(_ sender: Any) {
        vwUploadFile.isHidden = false
        btnImg.isHidden = true
        imageVw.isHidden = true
    }
    @IBAction func actionChooseFile(_ sender: Any) {
        MediaPicker.shared.setupPicker(delegate: self, allowVideoSelectionOnly: false)
        MediaPicker.shared.openActionSheetForImagePicker()
    }
    
    
    @IBAction func actionMenuBtnPress(_ sender: UIButton) {
//        dropDown.dataSource = ["Attendance History", "Logout"]
//        dropDown.anchorView = sender
//        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
//        dropDown.show()
//        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
//            if index == 0 {
//                self?.moveToNext(AttendanceHistoryVC.typeName, storyBoard: StoryBoard.main)
//            } else {
//                RootControllerProxy.shared.setRoot(LoginVC.typeName)
//            }
//        }
        
        var menuItems = ["Logout"]
        
        if AppCache.shared.currentUser?.data?.access?.fleet == true {
            menuItems.insert("Attendance History", at: 0)
        }
        
        dropDown.dataSource = menuItems
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            if item == "Attendance History" {
                self.moveToNext(AttendanceHistoryVC.typeName, storyBoard: StoryBoard.main)
            } else if item == "Logout" {
                RootControllerProxy.shared.setRoot(LoginVC.typeName)
            }
        }
        
    }
    

    
    func addDottedBorder(to view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = view.bounds
        shapeLayer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.gray.cgColor // Set the color of the border
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [6, 3] // Lengths of the dashes and gaps in the border
        let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 8) // Set the corner radius if needed
        shapeLayer.path = path.cgPath
        view.layer.addSublayer(shapeLayer)
    }
    // Updated code if billImageFile is a UIImage
    func setRequestModelValues() {
        self.viewModel.requestModel.vehicleId = UserAttandanceData.shared.vehicleId
        self.viewModel.requestModel.driverId = UserAttandanceData.shared.driverID
        // self.viewModel.requestModel.billAmount = 99
        self.viewModel.requestModel.billImage = viewModel.upload
        
        if let amountText = txtFldAmount.text, let amount = Int(amountText) {
            self.viewModel.requestModel.billAmount = amount
        } else {
            self.viewModel.requestModel.billAmount = 0 // Set a default value or handle error
        }
    }
    
    func setUpRequestModel(){
        //viewModel.requestupladFile.file = self.imageVw.image ?? UIImage()
        
       
    }
}
// MARK: - MediaPickerDelegate
extension ExpanceVC: MediaPickerDelegate {
    func mediaPicker(_ mediaPicker: MediaPicker, didChooseImage image: UIImage?, imageName: String?) {
        imageVw.image = image ?? UIImage(named: "ic_defaultSquare")
        // self.imageVw.imageURL("\(String(describing: self.viewModel.requestModel.billImageFile))")
        vwUploadFile.isHidden = true
        imageVw.isHidden = false
        btnImg.isHidden = false
        setUpRequestModel()
      //  self.addPhotos()
        viewModel.requestupladFile.file = image?.jpegData(compressionQuality: 0.2)
        uploadImgApi()
    }
}
extension ExpanceVC{
    func addEditProfileData(){
        CustomLoader.shared.show()
        viewModel.addExpenseDetails { result in
            CustomLoader.shared.hide()
            switch result{
            case .success(let response):
                self.showAlert(title: AppConstants.appName, message: "Upload sucessfull") { index in
                    DispatchQueue.main.async {
                        self.vwUploadFile.isHidden = false
                        self.imageVw.isHidden = true
                        self.btnImg.isHidden = true
                        self.txtFldAmount.text = ""
                    }
                }
            case .failure(let error):
                self.showAlert(title: AppConstants.appName, message: error.message)
            }
        }
    }
}


//MARK: API CALL
extension ExpanceVC{
//    func addPhotos(){
//        CustomLoader.shared.show()
//        viewModel.uploadIdProofs { result in
//            CustomLoader.shared.hide()
//            switch result{
//            case .success(let response):
//             //   if self.viewModel.isFromReject{
////                    guard let sendBack = self.viewModel.cb else {return}
////                    sendBack(true)
////                    self.popToBack()
////                }else{
//                    self.showAlert(title: AppConstants.appName, message: response.message) { index in
//                   
//                   // }
//                }
//               
//            case .failure(let error):
//                self.showAlert(title: AppConstants.appName, message: error.message)
//            }
//        }
//    }
    
    
    func uploadImgApi() {
        CustomLoader.shared.show()
        viewModel.uplaodImage { (result) in
            CustomLoader.shared.hide()
            switch result {
            case .success(_):
                print("***Success***")
            case .failure(let errorBlock):
                self.showAlertWithText(errorBlock.message)
            }
        }
    }
    
}

extension ExpanceVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtFldAmount {
            if string.contains(" ") {
                return false
            }
        }
        return true
    }
}
