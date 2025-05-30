//
//  ScanQRCodeVM.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 30/07/24.
//

import Foundation
import Foundation

class ScanQRCodeVM: NSObject {
    var apiService = AuthenticationApiServices()
    var responseModel: GetVehicleByVehicleNumberResponseModel?
    func getVehicleByVehicleNumber(vehicleNumber: String,compId:Int ,completion: @escaping ApiResponseCompletion) {
        apiService.getVehicleByVehicleNumber(vehicleNumber: vehicleNumber,compId: compId) { result in
            switch result {
            case .success(let response):
                print("response::", response)
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: "Data not found.")))
                    return
                }
                do {
                    self.responseModel = try JSONDecoder().decode(GetVehicleByVehicleNumberResponseModel.self, from: data)
                    
                    UserAttandanceData.shared.vehicleNumber = self.responseModel?.data?.vehicleNumber ?? ""
                    print("vehicleNumber::",self.responseModel?.data?.vehicleNumber ?? "")
                    print("vehicleId::",self.responseModel?.data?.id ?? 0)
                    UserAttandanceData.shared.vehicleId = self.responseModel?.data?.id ?? 0
                    UserDefaultsManager.shared.saveValue(self.responseModel?.data?.vehicleNumber ?? "", forKey: .vehicleNumber)
                    UserDefaultsManager.shared.saveValue(self.responseModel?.data?.id ?? "", forKey: .vehicleId)
                    
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
