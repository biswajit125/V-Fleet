//
//  ScanQRCodeVC.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 19/07/24.
//

import UIKit
import AVFoundation

class ScanQRCodeVC: UIViewController, UIGestureRecognizerDelegate,AlertProtocol {

    @IBOutlet weak var vwScanORCode: UIView!
    @IBOutlet weak var vwCameraContainer: UIView!
    @IBOutlet weak var txtFldVehiclenumber: UITextField!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var captureDevice: AVCaptureDevice!
    let viewModel = ScanQRCodeVM()
    
    var codeFound = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientToScanORCode()

      //  self.navigationItem.title = "Scan"
       // initialUISetup()
       // txtFldVehiclenumber.text = "WB02AL7044"
        captureSetup()
        hilightViewSetup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.view.addGestureRecognizer(tap)

        vwScanORCode.clipsToBounds = true
        vwScanORCode.layer.cornerRadius = 16
        vwScanORCode.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func addGradientToScanORCode() {
        // Remove any existing gradient layers before adding a new one
        vwScanORCode.layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = vwScanORCode.bounds
        gradientLayer.colors = [AppColor.vwBlue!.cgColor, AppColor.vwGray!.cgColor] // Set your gradient colors here
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Top center
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // Bottom center
        vwScanORCode.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func actionLoginWithNumber(_ sender: UIButton) {
        if let vehicleNumber = self.txtFldVehiclenumber.text, !vehicleNumber.isEmpty {
            getVehicleByVehicleNumber(vehicleNumber: vehicleNumber, compId: AppCache.shared.currentUser?.data?.superCompanyID ?? 0)
            UserAttandanceData.shared.vehicleNumber = self.txtFldVehiclenumber.text ?? ""
            
        } else {
            showAlert(title: AppConstants.appName, message: "Please enter a vehicle number")
        }
        
    }
    
    @IBAction func actionLogOut(_ sender: Any) {
        RootControllerProxy.shared.setRoot(LoginVC.typeName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        codeFound = false
        qrCodeFrameView?.frame = CGRect.zero
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
       // toggleFlashUI()
    }
    override func viewDidDisappear(_ animated: Bool) {
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
//    func initialUISetup() {
//        let username = UserDefaults.standard.string(forKey: "username")
//        lblPageHeader.text = "Welcome \(username ?? "")"
//        
//        vwBodyContainer.layer.cornerRadius = 30
//        vwBodyContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        
//        btnFlash.layer.borderWidth = 1
//        btnFlash.layer.borderColor = UIColor.appTint.cgColor
//    }
    @objc func tapAction() {
        self.view.endEditing(true)
    }
    
//    @IBAction func logoutBtnAction(_ sender: UIButton) {
//        self.showLogoutAlert()
//    }
    
//    @IBAction func flashBtnAction(_ sender: UIButton) {
//        toggleFlash()
//    }
    
//    @IBAction func submitVechicleNumber(_ sender: LoaderButton) {
//        if txtVechicleNumber.text?.isEmpty == true {
//            txtVechicleNumber.resignFirstResponder()
//            self.singleBtnAlertAlert(msg: "Please enter a vechicle number.") {}
//        } else {
//            getVechicleDetails()
//        }
//    }
    
//    func toggleFlashUI() {
//        if let device = captureDevice {
//            if device.torchMode == .on {
//                btnFlash.backgroundColor = UIColor.clear
//                btnFlash.tintColor = UIColor.appTint
//            } else {
//                btnFlash.backgroundColor = UIColor.appTint
//                btnFlash.tintColor = UIColor.whiteBg
//            }
//        } else {
//            btnFlash.backgroundColor = UIColor.appTint
//            btnFlash.tintColor = UIColor.whiteBg
//        }
//
//    }
    
//    func showLogoutAlert() {
//        let alertView = Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)?.first as! CustomAlertView
//        alertView.frame = UIScreen.main.bounds
//        alertView.center = self.view.center
//        alertView.layer.shadowColor = UIColor.lightGray.cgColor
//        alertView.layer.shadowOpacity = 1
//        alertView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        alertView.layer.shadowRadius = 10
//        alertView.lblMsg.text = "Are you sure you want to logout?"
//        alertView.noBtnActionHandler = {
//            alertView.removeWithAnimation()
//        }
//        alertView.yesBtnActionHandler = {
//            alertView.removeWithAnimation()
//            self.backToLogin()
//        }
//        alertView.showWithAnimation(in: self.view)
//    }
//    func backToLogin() {
//        if let viewControllers = self.navigationController?.viewControllers {
//            for viewController in viewControllers {
//                if viewController is ViewController {
//                    self.navigationController?.popToViewController(viewController, animated: true)
//                    break
//                }
//            }
//        }
//    }
//    func singleBtnAlertAlert(msg: String, completion: @escaping () -> Void) {
//        let alertView = Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)?.first as! CustomAlertView
//        alertView.frame = UIScreen.main.bounds
//        alertView.center = self.view.center
//        alertView.layer.shadowColor = UIColor.lightGray.cgColor
//        alertView.layer.shadowOpacity = 1
//        alertView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        alertView.layer.shadowRadius = 10
//        alertView.lblMsg.text = msg
//        alertView.noBtnActionHandler = {
//            alertView.removeWithAnimation()
//            completion()
//        }
//        alertView.yesBtnActionHandler = {
//            alertView.removeWithAnimation()
//            completion()
//        }
//        alertView.btn1.isHidden = true
//        alertView.btn2.setTitle("Ok", for: .normal)
//        alertView.showWithAnimation(in: self.view)
//    }
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        return (touch.view != btnSubmitVechicleNumber)
//    }
}

//MARK: - capture methods
extension ScanQRCodeVC {
    func captureSetup() {
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
//            self.singleBtnAlertAlert(msg: "Failed to get the camera device") {
//                //self.navigationController?.popViewController(animated: true)
//                //self.foundCode(type: .qr, value: "{\"vehicleNumber\":\"WB02AL7011\",\"Imei\":\"350544504413736\",\"id\":1}")
//            }
            
            return
        }
        
        self.captureDevice = captureDevice

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Lock the device configuration before making any changes
            try captureDevice.lockForConfiguration()
            
            // Set focus mode (for example, to continuous autofocus)
            if captureDevice.isFocusModeSupported(.continuousAutoFocus) {
                captureDevice.focusMode = .continuousAutoFocus
            }
            
            // Unlock the device configuration after making changes
            captureDevice.unlockForConfiguration()
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr, .code128, .code39, .code93, .ean13, .ean8, .pdf417, .code39Mod43, .upce]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = vwCameraContainer.layer.bounds
            vwCameraContainer.layer.addSublayer(videoPreviewLayer!)
            // Start video capture.
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
            

        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func hilightViewSetup() {
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            vwCameraContainer.addSubview(qrCodeFrameView)
            vwCameraContainer.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
//    func toggleFlash() {
//        guard let device = captureDevice else { return }
//        
//        if device.hasTorch {
//            do {
//                try device.lockForConfiguration()
//                if device.isTorchAvailable {
//                    device.torchMode = (device.torchMode == .off) ? .on : .off
//                }
//                device.unlockForConfiguration()
//                toggleFlashUI()
//            } catch {
//                print("Torch could not be used")
//            }
//        }
//    }
    
//    func getVechicleDetails() {
//        txtVechicleNumber.resignFirstResponder()
//        btnSubmitVechicleNumber.isLoading = true
//        WebServiceCalls.shared.fuelApiCall(endPoint: "/api/mobile/Vehicle/getVehicleDetails", method: "GET", body: [:]) { msg, status, data in
//            DispatchQueue.main.async {
//                self.btnSubmitVechicleNumber.isLoading = false
//                do {
//                    switch status {
//                    case 1 :
//                        guard let data = data else { return }
//                        let decoder = JSONDecoder()
//                        let decodeddata = try decoder.decode([VechicleModel].self, from: data)
//                        let vechicle = decodeddata.first(where: {$0.vehicleNumber?.lowercased() == self.txtVechicleNumber.text?.lowercased()})
//                        if vechicle != nil {
//                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddFuelDetailsVC") as? AddFuelDetailsVC {
//                                vc.vechicleNumber = vechicle?.vehicleNumber
//                                vc.vechicleId = vechicle?.id
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            }
//                        } else {
//                            self.singleBtnAlertAlert(msg: "Entered Vechicle Not found.") {}
//                        }
//                    case 2:
//                        self.singleBtnAlertAlert(msg: "Unable to get data from server.") {}
//                    case 3:
//                        self.singleBtnAlertAlert(msg: "Unable to get data from server.") {}
//                    default:
//                        print("at default.will never execute")
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
//    }
}

//MARK: - capture delegate
extension ScanQRCodeVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if codeFound {
            return // Stop processing if a code has already been found
        }
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.foundCode(type: .qr, value: metadataObj.stringValue!)
//                self.showAlert(withMsg: "scanned qr --> \(metadataObj.stringValue ?? "")")
            }
        } else {  //if metadataObj.type == AVMetadataObject.ObjectType.code128
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            print("type is ", metadataObj.type)
            if metadataObj.stringValue != nil {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.foundCode(type: .barcode, value: metadataObj.stringValue!)
//                self.showAlert(withMsg: "scanned barcode --> \(metadataObj.stringValue ?? "")")
            }
         }
        
    }
    
    func foundCode(type: ScannedCodeType, value: String) {
        codeFound = true
        let jsonData = value.data(using: .utf8) ?? Data()
        do {
            let qrdata = try JSONDecoder().decode(QRDataModel.self, from: jsonData)
            print(qrdata.vehicleNumber ?? "")
            print(qrdata.id as Any)
            print(qrdata.superCompanyId as Any)
            
            UserAttandanceData.shared.vehicleNumber = qrdata.vehicleNumber ?? ""
            UserAttandanceData.shared.vehicleId = qrdata.id ?? 0
            UserAttandanceData.shared.superCompanyID = qrdata.superCompanyId ?? 0
            
            
            UserDefaultsManager.shared.saveValue(qrdata.vehicleNumber ?? "", forKey: .vehicleNumber)
            UserDefaultsManager.shared.saveValue(qrdata.id ?? 0, forKey: .vehicleId)
        
            
            codeFound = true
            print("superCompanyID::",AppCache.shared.currentUser?.data?.superCompanyID)
            
            if UserAttandanceData.shared.superCompanyID == qrdata.superCompanyId {
                let vc = StoryBoard.menu.instantiateViewController(withIdentifier: RoundedTabbarController.typeName) as! RoundedTabbarController
    //            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddFuelDetailsVC") as? AddFuelDetailsVC {
                   // vc.vechicleNumber = qrdata.vehicleNumber
    //                vc.vechicleId = qrdata.id
                    self.navigationController?.pushViewController(vc, animated: true)
    //            }
            }else {
                self.codeFound = false
                self.showAlert(title: AlertsNames.error.rawValue, message: "vehicle number is not found")
                
            }
        } catch {
            print("Error decoding JSON: \(error)")
           // self.singleBtnAlertAlert(msg: "Vechicle number not found in QR Code. Please scan again.") {
                self.codeFound = false
                self.qrCodeFrameView?.frame = CGRect.zero
         //   }
            
            return
        }

    }
    
//    func foundCode(type: ScannedCodeType, value: String) {
//        codeFound = true
//        let jsonData = value.data(using: .utf8) ?? Data()
//        do {
//            let qrdata = try JSONDecoder().decode(QRDataModel.self, from: jsonData)
//            print(qrdata.vehicleNumber as Any)
//            print(qrdata.id as Any)
//            print(qrdata.superCompanyId as Any)
//            
//            guard let currentUserSuperCompanyID = AppCache.shared.currentUser?.data?.superCompanyID else {
//                self.showAlert(title: "Error", message: "User data not found. Please login again.")
//                self.codeFound = false
//                self.qrCodeFrameView?.frame = CGRect.zero
//                return
//            }
//            
//            if currentUserSuperCompanyID == qrdata.superCompanyId {
//                UserAttandanceData.shared.vehicleNumber = qrdata.vehicleNumber ?? ""
//                UserAttandanceData.shared.vehicleId = qrdata.id ?? 0
//                UserAttandanceData.shared.superCompanyID = qrdata.superCompanyId ?? 0
//                
//                UserDefaultsManager.shared.saveValue(qrdata.vehicleNumber ?? "", forKey: .vehicleNumber)
//                UserDefaultsManager.shared.saveValue(qrdata.id ?? 0, forKey: .vehicleId)
//                
//                let vc = StoryBoard.menu.instantiateViewController(withIdentifier: RoundedTabbarController.typeName) as! RoundedTabbarController
//                self.navigationController?.pushViewController(vc, animated: true)
//              
//            } else {
//                self.showAlert(title: "Error", message: "Super Company ID does not match. Please scan a valid QR code.")
//                self.codeFound = false
//                self.qrCodeFrameView?.frame = CGRect.zero
//            }
//        } catch {
//            print("Error decoding JSON: \(error)")
//            self.showAlert(title: "Error", message: "Vechicle number not found in QR Code. Please scan again.")
//            self.codeFound = false
//            self.qrCodeFrameView?.frame = CGRect.zero
//        }
//    }

}


    


extension ScanQRCodeVC {
    func getVehicleByVehicleNumber(vehicleNumber:String,compId: Int) {
        CustomLoader.shared.show()
        viewModel.getVehicleByVehicleNumber(vehicleNumber:vehicleNumber,compId: compId) { [weak self] (result) in
            CustomLoader.shared.hide()
            switch result {
            case .success(let response):
                print("getVehicleByVehicleNumber sucess")
                //  self?.moveToNext(ScanQRCodeVC.typeName)
                print("response::",response.status)
                let vc = StoryBoard.menu.instantiateViewController(withIdentifier: RoundedTabbarController.typeName) as! RoundedTabbarController
                
                
                
                //                DispatchQueue.main.async {
                //                    UserAttandanceData.shared.vehicleNumber = self?.viewModel.responseModel.data?.vehicleNumber ?? ""
                //
                //                    print("vehicleNumber::",self?.viewModel.responseModel.data?.vehicleNumber ?? "")
                //                    print("vehicleId::",self?.viewModel.responseModel.data?.id ?? 0)
                //                    UserAttandanceData.shared.vehicleId = self?.viewModel.responseModel.data?.id ?? 0
                //                }
                
                DispatchQueue.main.async {
                    
                    
                }
                
                
                self?.navigationController?.pushViewController(vc, animated: true)
                
                print("response::",response)
                
            case .failure(let error):
                self?.showAlert(title: AlertsNames.error.rawValue, message: error.message)
            }
        }
    }
}

