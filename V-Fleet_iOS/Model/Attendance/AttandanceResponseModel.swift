//
//  AttandanceResponseModel.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 24/07/24.
//

import Foundation


//// MARK: - AttandanceResponseModel
//struct AttandanceResponseModel: Codable {
//    let message: String?
//    let status: Int?
//}


// MARK: - AttandanceResponseModel
struct AttandanceResponseModel: Codable {
    var data: AttandanceResponseData?
    var message: String?
    var status: Int?
}

// MARK: - DataClass
struct AttandanceResponseData: Codable {
    var id, driverID, vehicleID: Int?
    var startTime: String?
    var startLatitude, startLongitude: Double?
    var startLocation, stopLocation, endTime, date: String?
    var status, totalHours: String?
    var activeAttandance: Bool?
    var superCompanyID, companyID: Int?
    var vehicleNumber, driverName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case driverID = "driverId"
        case vehicleID = "vehicleId"
        case activeAttandance = "active"
        case startTime, startLatitude, startLongitude, startLocation, stopLocation, endTime, date, status, totalHours
        case superCompanyID = "superCompanyId"
        case companyID = "companyId"
        case vehicleNumber, driverName
    }
}
