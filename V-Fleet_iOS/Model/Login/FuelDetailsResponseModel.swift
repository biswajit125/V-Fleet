//
//  FuelDetailsResponseModel.swift
//  V-Fleet_iOS
//
//  Created by Yagnesh Bagrodia on 30/05/25.
//

import Foundation


// MARK: - GetFuelInfoForOfflineSyncForAllVehiclesResponseModel
struct FuelDetailsResponseModel: Codable {
    var data: [FuelDetailsResponseDataModel]?
    var message: String?
    var status: Int?
}

// MARK: - GetFuelInfoForOfflineSyncForAllVehiclesResponseData
struct FuelDetailsResponseDataModel: Codable {
    var previousOdometer: Int?
    var averageMileage: Double?
    var fuelCountByVehicleID, previousMileage, vehicleID, prevQuantityFilled: Int?
    var totalUnusedFuel, remainFuel: Int?

    enum CodingKeys: String, CodingKey {
        case previousOdometer, averageMileage
        case fuelCountByVehicleID = "fuelCountByVehicleId"
        case previousMileage
        case vehicleID = "vehicleId"
        case prevQuantityFilled, totalUnusedFuel, remainFuel
    }
}

