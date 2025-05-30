//
//  AttandanceRequestModel.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 24/07/24.
//

import Foundation

struct AttandanceRequestModel: Codable {
    var driverId: Int?
    var vehicleId: Int?
    var startLatitude: Double?
    var startLongitude: Double?
    var startLocation: String?
    
//    var endLatitude: Double?
//    var endLongitude: Double?
//    var endLocation: String?
    
    var superCompanyId: Int?
    var companyId: Int?
    var vehicleNumber: String?
    var driverName: String?
    
    var validationMsg: String? {
        if driverId == nil {
            return "Driver ID is required."
        }
        if vehicleId == nil {
            return "Vehicle ID is required."
        }
        if startLatitude == nil {
            return "Start Latitude is required."
        }
        if startLongitude == nil {
            return "Start Longitude is required."
        }
        if startLocation?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            return "Start Location is required."
        }
        if superCompanyId == nil {
            return "Super Company ID is required."
        }
        if companyId == nil {
            return "Company ID is required."
        }
        if vehicleNumber?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            return "Vehicle Number is required."
        }
        if driverName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            return "Driver Name is required."
        }
        return nil
    }
}

struct AttandanceStopRequestModel: Codable {
    var driverId: Int?
    var vehicleId: Int?
//    var startLatitude: Double?
//    var startLongitude: Double?
     var startLocation: String?
//
    var endLatitude: Double?
    var endLongitude: Double?
    var stopLocation: String?
    
    var superCompanyId: Int?
    var companyId: Int?
    var vehicleNumber: String?
    var driverName: String?
    
    var validationMsg: String? {
        if driverId == nil {
            return "Driver ID is required."
        }
        if vehicleId == nil {
            return "Vehicle ID is required."
        }
        if endLatitude == nil {
            return "Stop Latitude is required."
        }
        if stopLocation == nil {
            return "Stop Longitude is required."
        }
        if startLocation?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            return "Stop Location is required."
        }
        if superCompanyId == nil {
            return "Super Company ID is required."
        }
        if companyId == nil {
            return "Company ID is required."
        }
        if vehicleNumber?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            return "Vehicle Number is required."
        }
        if driverName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            return "Driver Name is required."
        }
        return nil
    }
}
