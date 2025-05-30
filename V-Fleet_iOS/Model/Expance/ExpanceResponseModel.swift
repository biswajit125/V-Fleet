//
//  ExpanceResponseModel.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 25/07/24.
//

import Foundation
import UIKit

struct ExpenseDetailsRequestModel: Codable {
    var vehicleId: Int?
    var driverId: Int?
    var billAmount: Int?
    var billImage: String?

    enum CodingKeys: String, CodingKey {
        case vehicleId, driverId, billAmount, billImage
    }

//    var json: [String: Any] {
//        guard let data = try? JSONEncoder().encode(self),
//              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//            return [:]
//        }
//        return dictionary
//    }



    func validationMessage() -> String? {
        if billImage == nil {
            return "Please upload images."
        }
        // Add other validation messages as needed
        return nil
    }
}

