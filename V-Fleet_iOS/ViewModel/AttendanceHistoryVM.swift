//
//  AttendanceHistoryVM.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 01/08/24.
//

import Foundation

class AttendanceHistoryVM: NSObject {
    var apiService = AuthenticationApiServices()
    var responseModel: AttendanceHistoryResponseModel?
    func getAttendanceReportByUser(userId: Int,completion: @escaping ApiResponseCompletion) {
        apiService.getAttendanceReportByUser(userId: userId) { result in
            switch result {
            case .success(let response):
                print("response::")
                if let jsonString = String(data: response.data as? Data ?? Data(), encoding: .utf8) {
                    print("Result Data JSON String: 12 \(jsonString)")
                } else {
                    print("Failed to convert resultData to String.")
                }
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: response.message)))
                    return
                }
                do {
                    self.responseModel = try JSONDecoder().decode(AttendanceHistoryResponseModel.self, from: data)
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

