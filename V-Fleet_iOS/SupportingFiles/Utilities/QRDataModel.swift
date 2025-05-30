//
//  QRDataModel.swift
//  Fuel Management System
//
//  Created by Supriyo Dey on 12/12/23.
//

import Foundation

struct QRDataModel: Decodable {
    var vehicleNumber: String?
    var superCompanyId: Int?
    var id: Int?
}

// MARK: - GetAllVehicleDetailsResponseModel
struct GetAllVehicleDetailsResponseModel: Codable {
    var data: [GetAllVehicleDetailsResponseData]?
    var message: String?
    var status: Int?
}

// MARK: - GetAllVehicleDetailsResponseData
struct GetAllVehicleDetailsResponseData: Codable {
    var id: Int?
    var vehicleNumber: String?
    var noOfWheel: Int?
    var qrCode: [Int]?
    var active: Bool?
    var model, brand, type: String?
    var capacity: Capacity?
    var superCompanyID, companyID: Int?

    enum CodingKeys: String, CodingKey {
        case id, vehicleNumber, noOfWheel, qrCode, active, model, brand, type, capacity
        case superCompanyID = "superCompanyId"
        case companyID = "companyId"
    }
}

enum Capacity: String, Codable {
    case the4Seater = "4-Seater"
    case the6Seater = "6-Seater"
}
