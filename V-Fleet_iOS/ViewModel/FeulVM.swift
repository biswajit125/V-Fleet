//
//  FeulVM.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 25/07/24.
//

import Foundation

class FeulVM: NSObject {
    var requestModel = FeulRequestModel()
    var apiService = AuthenticationApiServices()
    var responseModel: FeulResponseModel?
    var postFuelDetailsRequestModel = PostFuelDetailsRequestModel()
    var postFuelDetailsResponseModel : AttandanceResponseModel?
    var requestupladFile = AddIdProofsRequestModel()
    var prevMileageResponseModel : PrevMileageResponseModel?
    var getLastVehicleInfoAtRefuelingRequestModel: GetLastVehicleInfoAtRefuelingResponseModel?
    var upload : String? = ""

    func getVehicleInfoAtRefueling(vehicleId: Int,completion: @escaping ApiResponseCompletion) {
        apiService.getVehicleInfoAtRefueling(vehicleId: vehicleId) { result in
            switch result {
            case .success(let response):
                
                print("response::", response)
                if let jsonString = String(data: response.data as? Data ?? Data(), encoding: .utf8) {
                    print("Result Data JSON String: \(jsonString)")
                    
                } else {
                    print("Failed to convert resultData to String.")
                }
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: "Data not found.")))
                    return
                }
                do {
                    self.responseModel = try JSONDecoder().decode(FeulResponseModel.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Error decoding data: ", error.localizedDescription)
                    completion(.failure(ApiResponseErrorBlock(message: "\(error.localizedDescription).")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // New method to get previous mileage
    func getPrevMileage(vehicleId: Int, currentMileage: Double, completion: @escaping ApiResponseCompletion) {
        apiService.getPrevMileage(vehicleId: vehicleId, currentMileage: currentMileage) { result in
            switch result {
            case .success(let response):
                print("response::", response)
                if let jsonString = String(data: response.data as? Data ?? Data(), encoding: .utf8) {
                    print("Result Data JSON String: \(jsonString)")
                } else {
                    print("Failed to convert resultData to String.")
                }
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: "Data not found.")))
                    return
                }
                do {
                    // Assuming you have a model to decode the previous mileage response
                   
                    self.prevMileageResponseModel = try JSONDecoder().decode(PrevMileageResponseModel.self, from: data)
                    // Handle the mileageResponseModel as needed
                    completion(.success(response))
                } catch {
                    print("Error decoding data: ", error.localizedDescription)
                    completion(.failure(ApiResponseErrorBlock(message: "\(error.localizedDescription).")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
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
                        
                        print("Image:::",resp.data)
                        
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
    
    func postFuelDetails(userId: String,completion: @escaping ApiResponseCompletion) {
      let params = postFuelDetailsRequestModel.dictionary
        apiService.postFuelDetails(userId: userId, parameters: params) { result in
            switch result {
            case .success(let response):
                print("response::", response)
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: "Data not found.")))
                    return
                }
                do {
                    self.postFuelDetailsResponseModel = try JSONDecoder().decode(AttandanceResponseModel.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Error decoding data: ", error.localizedDescription)
                    completion(.failure(ApiResponseErrorBlock(message: "\(error.localizedDescription).")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
