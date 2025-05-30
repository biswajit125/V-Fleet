//
//  AttendanceVM.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 24/07/24.
//

import Foundation
import UIKit

class AttendanceVM: NSObject {
    var requestModel = AttandanceRequestModel()
    var stopRequestModel = AttandanceStopRequestModel()
    var apiService = AuthenticationApiServices()
    var responseModel: AttandanceResponseModel?
    
    func addSaveAttendance(completion: @escaping ApiResponseCompletion) {
        let params = requestModel.dictionary
        apiService.addSaveAttendance(params) { result in
            switch result {
            case .success(let response):
                print("response::")
                if let jsonString = String(data: response.data as? Data ?? Data(), encoding: .utf8) {
                    print("Result Data JSON String11: \(jsonString)")
                } else {
                    print("Failed to convert resultData to String.")
                }
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: response.message)))
                    return
                }
                do {
                    self.responseModel = try JSONDecoder().decode(AttandanceResponseModel.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Error decoding data:11 ", error.localizedDescription)
                    completion(.failure(ApiResponseErrorBlock(message: response.message)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func stopAttendance(completion: @escaping ApiResponseCompletion) {
        let params = stopRequestModel.dictionary
        apiService.addSaveAttendance(params) { result in
            switch result {
            case .success(let response):
                print("response::")
                if let jsonString = String(data: response.data as? Data ?? Data(), encoding: .utf8) {
                    print("Result Data JSON String: 11 \(jsonString)")
                } else {
                    print("Failed to convert resultData to String.")
                }
                
//                if response.status == 500 {
//                    Utility.showAlertOnWindow(withTitle: "",message: "You have already given the Attendance!" ,actionTitle1: "OK")
//                    return
//                }
                
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: response.message)))
                    return
                }
                do {
                    self.responseModel = try JSONDecoder().decode(AttandanceResponseModel.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Error decoding data: ", error.localizedDescription)
                    completion(.failure(ApiResponseErrorBlock(message: response.message)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func startShift(completion: @escaping ApiResponseCompletion) {
        let params = requestModel.dictionary
        apiService.startStopShift(params) { result in
            switch result {
            case .success(let response):
                print("response::")
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: response.message)))
                    return
                }
                do {
                    self.responseModel = try JSONDecoder().decode(AttandanceResponseModel.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Error decoding data: ", error.localizedDescription)
                    completion(.failure(ApiResponseErrorBlock(message: response.message)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func stopShift(completion: @escaping ApiResponseCompletion) {
        let params = stopRequestModel.dictionary
        apiService.startStopShift(params) { result in
            switch result {
            case .success(let response):
                print("response::")
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: response.message)))
                    return
                }
                do {
                    self.responseModel = try JSONDecoder().decode(AttandanceResponseModel.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Error decoding data: ", error.localizedDescription)
                    completion(.failure(ApiResponseErrorBlock(message: response.message)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
