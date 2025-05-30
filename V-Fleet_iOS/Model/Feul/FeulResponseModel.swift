//
//  FeulResponseModel.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 25/07/24.
//

import Foundation


//// MARK: - FeulResponseModel
//struct FeulResponseModel: Codable {
//    var data: FeulDataClass?
//    var message: String?
//    var status: Int?
//}
//
//// MARK: - DataClass
//struct FeulDataClass: Codable {
//    var previousOdometer, currentOdometer, previousMileage: Double?
//    var vehicleActive : Bool?
//    var location: String?
//}



// MARK: - FeulResponseModel
struct FeulResponseModel: Codable {
    var data: FeulDataClass?
    var message: String?
    var status: Int?
}

// MARK: - DataClass
struct FeulDataClass: Codable {
    var previousOdometer: Double?
    var vehicleActive: Bool?
    var currentOdometer, previousMileage :Double?
    var location: String?
}


// MARK: - GetLastVehicleInfoAtRefuelingRequestModel
struct GetLastVehicleInfoAtRefuelingResponseModel: Codable {
    var data: LastVehicleInfoAtRefuelingData?
    var message: String?
    var status: Int?
}

// MARK: - DataClass
struct LastVehicleInfoAtRefuelingData: Codable {
    var previousOdometer: Double?
    var averageMileage: Double?
    var prevQuantityFilled, totalUnusedFuel, remainFuel: Double?
}
