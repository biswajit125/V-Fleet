//
//  AttendanceHistoryResponseModel.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 01/08/24.
//

import Foundation

// MARK: - AttendanceHistoryResponseModel
struct AttendanceHistoryResponseModel: Codable {
    var data: [Datum]?
    var message: String?
    var status: Int?
}

// MARK: - Datum
struct Datum: Codable {
    var id, driverID, vehicleID: Int?
    var startTime: String?
    var startLatitude, startLongitude: Double?
    var startLocation, stopLocation: String?
    var endLatitude, endLongitude: Double?
    var endTime, date, status, totalHours: String?
    var active: Bool?
    var superCompanyID, companyID: Int?
    var vehicleNumber, driverName, parentCompany, company: String?

    enum CodingKeys: String, CodingKey {
        case id
        case driverID = "driverId"
        case vehicleID = "vehicleId"
        case startTime, startLatitude, startLongitude, startLocation, stopLocation, endLatitude, endLongitude, endTime, date, status, totalHours, active
        case superCompanyID = "superCompanyId"
        case companyID = "companyId"
        case vehicleNumber, driverName, parentCompany, company
    }
}
