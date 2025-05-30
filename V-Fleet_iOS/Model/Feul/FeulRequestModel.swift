//
//  FeulRequestModel.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 25/07/24.
//

import Foundation


import Foundation

struct FeulRequestModel: Codable {
    var vehicleId : Int?
    var validationMsg: String? {
        if vehicleId == nil {
            return "Date is required"
        }
        return nil
    }
}

struct PostFuelDetailsRequestModel: Codable {
    var vehicleId: Int?
    var odoValue : Double?
    var prevOdoValue : Double?
    var diffOdoValue: Double?
    var quantity: Double?
    var mileage : Double?
    var prevMileage: Double?
    var superCompanyId: Int?
    var companyId: Int?
    var location: String?
    var odometerImage: String?
    var fuelRemain : Double?
    
    var validationMsg: String? {
        if vehicleId == nil {
            print("Vehicle ID is missing.")
        }
        if odoValue == nil {
            print("ODO value is missing.")
        }
        if prevOdoValue == nil {
            print("Previous ODO value is missing.")
        }
        if quantity == nil {
            print("Quantity is missing.")
        }
        if mileage == nil {
            print("Mileage is missing.")
        }
        if prevMileage == nil {
            print("Previous mileage is missing.")
        }
        if superCompanyId == nil {
            print("Super company ID is missing.")
        }
        if companyId == nil {
            print("Company ID is missing.")
        }
        if location == nil || location?.isEmpty == true {
            print("Location is missing or empty.")
        }
        if odometerImage == nil || odometerImage?.isEmpty == true {
            print("Odometer image is missing or empty.")
        }
        if fuelRemain == nil {
            print("fuelRemain is missing.")
        }
        
        return nil
    }
}
