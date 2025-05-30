//
//  PrevMileageResponseModel.swift
//  FleetMate
//
//  Created by Bishwajit Kumar on 04/10/24.
//

import Foundation


struct PrevMileageResponseModel: Codable {
    var data: MileageData?
    var message: String?
    var status: Int?
    
    struct MileageData: Codable {
        var averageMileage: Double?
    }
}
