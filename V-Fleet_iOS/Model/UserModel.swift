//
//  UserModel.swift
//  Colorblind
//
//  Created by itechnolabs on 20/09/22.
//

import Foundation

// MARK: - DataClass
struct UserDataModel: Codable {
    var id: Int?
    var name: String?
    var profileName, firstName, lastName: String?
    var email: String?
    var countryCode, contactNo, emailVerifiedAt: String?
    var role: String?
    var remember, currentTeamID, profilePhotoPath, bannerImage: String?
    var headShot, fullBody: String?
    var status: Int?
    var abouts: String?
    var privacyPolicy, isAge: Int?
    var wallet: String?
    var categoryID: Int?
    var createdAt, updatedAt, customerID: String?
    var accountID: String?
    var token: String?
    var profilePhotoURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case profileName = "profile_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case countryCode = "country_code"
        case contactNo = "contact_no"
        case emailVerifiedAt = "email_verified_at"
        case role, remember
        case currentTeamID = "current_team_id"
        case profilePhotoPath = "profile_photo_path"
        case bannerImage = "banner_image"
        case headShot = "head_shot"
        case fullBody = "full_body"
        case status, abouts
        case privacyPolicy = "privacy_policy"
        case isAge = "is_age"
        case wallet
        case categoryID = "category_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case customerID = "customer_id"
        case accountID = "account_id"
        case token
        case profilePhotoURL = "profile_photo_url"
    }
}
