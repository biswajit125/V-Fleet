//
//  UploadImgRequestModel.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 30/07/24.
//

import Foundation
struct UploadImgRequestModel: Codable {
    var vehicleId: Int?
    var driverId: Int?
    var billAmount: Int?
    var billImageFile: Data?
    
    enum CodingKeys: String, CodingKey {
        case vehicleId,driverId,billAmount,billImageFile
    }

    var dict: [String: Data] {
        let dict = ["billImageFile": self.billImageFile!]
        
        return dict
    }

    var json: [String: Any] {
        let dictionary: [String: Any] = JSONEncoder().convertToDictionary(self) ?? [:]
        return dictionary
    }
}


// MARK: - ExpanceResponseModel
struct ExpanceResponseModel: Codable {
    var data: ExpanceDataClass?
    var message: String?
    var status: Int?
}

// MARK: - DataClass
struct ExpanceDataClass: Codable {
    var id, driverID, vehicleID: Int?
    var date, time, createdBy: String?
    var billAmount: Int?
    var billImage, approval, approvalDate, approvalTime: String?
    var status: Bool?
    var superCompanyID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case driverID = "driverId"
        case vehicleID = "vehicleId"
        case date, time, createdBy, billAmount, billImage, approval, approvalDate, approvalTime, status
        case superCompanyID = "superCompanyId"
    }
}
