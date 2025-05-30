//
//  ExpanceVM.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 25/07/24.
//

import Foundation
import UIKit


class ExpanceVM: NSObject {
    var requestModel : ExpenseDetailsRequestModel = ExpenseDetailsRequestModel()
    var apiService = AuthenticationApiServices()
    var objUploadImgRequestModel = UploadImgRequestModel()
    var responseModel : ExpanceResponseModel?
    var requestupladFile = AddIdProofsRequestModel()
    var uploadResponse : AddIdProofsResponseModel?
    var upload : String? = ""

    func addExpenseDetails(_ completion : @escaping ApiResponseCompletion){
        let params = requestModel.dictionary
       // let multipartData = requestModel.multipartModelArray
        apiService.addExpenseDetails(params) { result in
            switch result{
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
//    func uploadIdProofs(_ completion : @escaping ApiResponseCompletion){
//        let params = requestupladFile.json
//        //let multipart = requestupladFile.multipartModelArray
//        
//        apiService.upload(params) { result in
//            switch result{
//            case .success(let response):
//                completion(.success(response))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    // MARK: - CUSTOM FUNCTIONS
    func uplaodImage(completion: @escaping ApiResponseCompletion) {
        let params = self.requestupladFile.dict
        debugPrint(params)
        apiService.uploadImg(params, completionBlock: { (result) in
            switch result {
            case .success(let response):
                
                if let data = response.data as? JSONDictionary {
                    if let resp: AddIdProofsResponseModel = data.decodeDictionary(), let model = resp.data {
                        //        Proxy.shared.uploadImg = "https://shepherduser-uat.itechnolabs.tech:6001/\(model.profilePhoto!)"
                        
                        print("data image:::",resp.data ?? "")
                        self.upload = resp.data ?? ""
                        
                        UserDefaultsManager.shared.saveValue(resp.data ?? "", forKey: .uploadImage)
                        
                    }
                    
                        completion(.success(response))
                        return
                    //}
                }
                completion(.failure(ApiResponseErrorBlock(message: AlertMessages.errorInDataConversion)))
            
            case .failure(let error):
                ///Handle failure response
                completion(.failure(error))
            }
        })
    }
    
    
}


//struct AddIdProofsRequestModel :  Codable{
//    
//    var file  = UIImage()
//    var userId : Int?
//   // var re_submit : Bool?
//    
//    
//    enum CodingKeys : String , CodingKey{
//        case userId = "user_id"
//      //  case re_submit
//      //  case file
//    }
//    
//    var json: [String: Any] {
//        let dictionary: [String: Any] = JSONEncoder().convertToDictionary(self) ?? [:]
//        return dictionary
//    }
//    
//    var multipartModelArray: [MultipartModel] {
//        var images = [MultipartModel]()
//        for img in file{
//            images.append(MultipartModel(key: "file", data: img.jpegData(compressionQuality: 0.2), url: nil, mimeType: .image, fileName: "image.png"))
//        }
//        return images
//    }
//}

//struct AddIdProofsRequestModel: Codable {
//    var file: UIImage?
//    var userId: Int?
//    
//    enum CodingKeys: String, CodingKey {
//        case userId = "user_id"
//    }
//    
//    var json: [String: Any] {
//        let dictionary: [String: Any] = JSONEncoder().convertToDictionary(self) ?? [:]
//        return dictionary
//    }
//    
//    var multipartModelArray: [MultipartModel] {
//        var images = [MultipartModel]()
//        if let img = file, let imageData = img.jpegData(compressionQuality: 0.2) {
//            images.append(MultipartModel(key: "file", data: imageData, url: nil, mimeType: .image, fileName: "image.png"))
//        }
//        return images
//    }
//}


struct AddIdProofsRequestModel: Codable {
    var file: Data?
    
    enum CodingKeys: String, CodingKey {
        case file
    }

    var dict: [String: Data] {
        let dict = ["file": self.file!]
        
        return dict
    }

    var json: [String: Any] {
        let dictionary: [String: Any] = JSONEncoder().convertToDictionary(self) ?? [:]
        return dictionary
    }
}




struct AddIdProofsResponseModel: Codable {
    var data: String?
    var message: String?
    var status: Int?
}
