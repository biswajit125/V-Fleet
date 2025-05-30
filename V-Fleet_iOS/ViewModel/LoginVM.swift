//
//  LoginVM.swift
//  PocketITNerd
//
//  Created by ashish mehta on 11/10/22.
//

import Foundation

class LoginVM: NSObject {
    var requestModel = LoginRequestModel()
    var apiService = AuthenticationApiServices()
    var responseModel: LoginResponseModel?
    var alertMessage = ""
    var userDataResponseModel: UserDetailsResponseModel?
    let dbHelper = DatabaseHelper.shared
    var getAllVehicleDetailsResponseModel: GetAllVehicleDetailsResponseModel?
    var fuelDetailsResponseModel : FuelDetailsResponseModel?
    
    func login(completion: @escaping ApiResponseCompletion) {
        let params = requestModel.dictionary
        apiService.login(params) { result in
            switch result {
            case .success(let response):
                if let jsonString = String(data: response.data as? Data ?? Data(), encoding: .utf8) {
                    print("Result Data JSON String: \(jsonString)")
                    self.alertMessage = response.message
                    print("message::",response.message)
                    
                } else {
                    print("Failed to convert resultData to String.")
                }
                
                print("response111:: ", response.data as Any)
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: "Data not found.")))
                    return
                }
                do {
                    self.responseModel = try JSONDecoder().decode(LoginResponseModel.self, from: data)
                   AppCache.shared.currentUser = self.responseModel
                    
                    let attendanceStatus = self.responseModel?.data?.attendanceStatus ?? false
                    let shiftStatus = self.responseModel?.data?.shiftStatus ?? false
                    let companyId = self.responseModel?.data?.superCompanyID ?? 0
                    
                    UserDefaultsManager.shared.saveValue(attendanceStatus, forKey: .attendance_Status)
                    UserDefaultsManager.shared.saveValue(shiftStatus, forKey: .shift_Status)
                    UserDefaultsManager.shared.saveValue(companyId, forKey: .superCompanyID)
                
                    //Get value from userdefault
                    if let currentUser = AppCache.shared.currentUser {
                        let attendanceStatus = currentUser.data?.attendanceStatus ?? false
                        let shiftStatus = currentUser.data?.shiftStatus ?? false
                        print("attendanceStatus :: LoginVM>>> ", attendanceStatus)
                        print("shiftStatus :: LoginVM>>> ", shiftStatus)
                    }
                    
                    completion(.success(response))
                 
                    
                } catch {
                    print("Error decoding data: ", error.localizedDescription)
                    completion(.failure(ApiResponseErrorBlock(message: "\(response.message).")))
                }
 
                print("data::",data)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
//    func login(completion: @escaping ApiResponseCompletion) {
//        let params = requestModel.dictionary
//        apiService.login(params) { result in
//            switch result {
//            case .success(let response):
//                if let jsonString = String(data: response.data as? Data ?? Data(), encoding: .utf8) {
//                    print("Result Data JSON String: \(jsonString)")
//                    self.alertMessage = response.message
//                    print("message::", response.message)
//                } else {
//                    print("Failed to convert resultData to String.")
//                }
//
//                print("response111:: ", response.data as Any)
//                guard let data = response.data as? Data else {
//                    completion(.failure(ApiResponseErrorBlock(message: "Data not found.")))
//                    return
//                }
//                do {
//                    self.responseModel = try JSONDecoder().decode(LoginResponseModel.self, from: data)
//                    AppCache.shared.currentUser = self.responseModel
//
//                    let attendanceStatus = self.responseModel?.data?.attendanceStatus ?? false
//                    let shiftStatus = self.responseModel?.data?.shiftStatus ?? false
//
//                    UserDefaultsManager.shared.saveValue(attendanceStatus, forKey: .attendance_Status)
//                    UserDefaultsManager.shared.saveValue(shiftStatus, forKey: .shift_Status)
//
//                    completion(.success(response))
//                } catch {
//                    print("Error decoding data: ", error.localizedDescription)
//                    completion(.failure(ApiResponseErrorBlock(message: "\(response.message).")))
//                }
//
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
//    func getAllUsersData(completion: @escaping ApiResponseCompletion) {
//        apiService.getAllUserDetails() { result in
//            switch result {
//            case .success(let response):
//                guard let data = response.data as? Data else {
//                    completion(.failure(ApiResponseErrorBlock(message: "Data not found.")))
//                    return
//                }
//                do {
//                    self.userDataResponseModel = try JSONDecoder().decode(UserDetailsResponseModel.self, from: data)
//                    
//                    // Print user details without optionals
//                    if let users = self.userDataResponseModel?.data {
//                        for user in users {
//                            
//                            DatabaseHelper.shared.insertUser(user)
//                            
//                        }
//                    } else {
//                        print("No user data found.")
//                    }
//                    
//                    completion(.success(response))
//                    
//                } catch {
//                    print("Error decoding data: ", error.localizedDescription)
//                    completion(.failure(ApiResponseErrorBlock(message: "\(response.message).")))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    func getAllUsersData(completion: @escaping ApiResponseCompletion) {
        apiService.getAllUserDetails() { result in
            switch result {
            case .success(let response):
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: "Data not found.")))
                    return
                }
                do {
                    self.userDataResponseModel = try JSONDecoder().decode(UserDetailsResponseModel.self, from: data)

                    if let users = self.userDataResponseModel?.data {
                        for user in users {
                            if let userId = user.id, DatabaseHelper.shared.isUserExists(id: Int64(userId)) {
                                DatabaseHelper.shared.updateUser(user)
                            } else {
                                DatabaseHelper.shared.insertUser(user)
                            }
                        }
                    } else {
                        print("No user data found.")
                    }

                    completion(.success(response))

                } catch {
                    print("Error decoding data: ", error.localizedDescription)
                    completion(.failure(ApiResponseErrorBlock(message: "\(response.message).")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

//    func getAllVehicleDetails(completion: @escaping ApiResponseCompletion) {
//        apiService.getAllVehicleDetails { result in
//            switch result {
//            case .success(let response):
//                guard let data = response.data as? Data else {
//                    completion(.failure(ApiResponseErrorBlock(message: "Invalid or missing data.")))
//                    return
//                }
//
//                do {
//                    let decodedResponse = try JSONDecoder().decode(GetAllVehicleDetailsResponseModel.self, from: data)
//                    self.getAllVehicleDetailsResponseModel = decodedResponse
//                    
//                    // Optional: Sync with local DB if needed
////                    if let vehicles = decodedResponse.data {
////                        for vehicle in vehicles {
////                            if let vehicleId = vehicle.id, DatabaseHelper.shared.isUserExists(id: Int64(vehicleId)) {
////                                DatabaseHelper.shared.updateUser(vehicle)
////                            } else {
////                                DatabaseHelper.shared.insertUser(vehicle)
////                            }
////                        }
////                    } else {
////                        print("No vehicle data found.")
////                    }
//
//                    completion(.success(response))
//
//                } catch {
//                    print("Decoding error: \(error.localizedDescription)")
//                    completion(.failure(ApiResponseErrorBlock(message: "Decoding error: \(error.localizedDescription)")))
//                }
//
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    func getAllVehicleDetails(completion: @escaping ApiResponseCompletion) {
        apiService.getAllVehicleDetails { result in
            switch result {
            case .success(let response):
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: "Invalid or missing data.")))
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(GetAllVehicleDetailsResponseModel.self, from: data)
                    self.getAllVehicleDetailsResponseModel = decodedResponse
                    
                    // Sync with local DB
                    if let vehiclesList = decodedResponse.data {
                        for vehicle in vehiclesList {
                            if let vehicleId = vehicle.id {
                                if DatabaseHelper.shared.isVehicleExists(id: Int64(vehicleId)) {
                                    DatabaseHelper.shared.updateVehicle(vehicle)
                                } else {
                                    DatabaseHelper.shared.insertVehicle(vehicle)
                                }
                            }
                        }
                    } else {
                        print("No vehicle data found.")
                    }

                    completion(.success(response))

                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(ApiResponseErrorBlock(message: "Decoding error: \(error.localizedDescription)")))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


//    func getFuelInfoForOfflineSyncForAllVehicles(completion: @escaping ApiResponseCompletion) {
//        apiService.getFuelInfoForOfflineSyncForAllVehicles { result in
//            switch result {
//            case .success(let response):
//                guard let data = response.data as? Data else {
//                    completion(.failure(ApiResponseErrorBlock(message: "Invalid or missing data.")))
//                    return
//                }
//
//                do {
//                    let decodedResponse = try JSONDecoder().decode(FuelDetailsResponseModel.self, from: data)
//                    self.fuelDetailsResponseModel = decodedResponse
//                    completion(.success(response))
//                } catch {
//                    print("Decoding error: \(error.localizedDescription)")
//                    completion(.failure(ApiResponseErrorBlock(message: "Failed to parse response.")))
//                }
//
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    func getFuelInfoForOfflineSyncForAllVehicles(completion: @escaping ApiResponseCompletion) {
        apiService.getFuelInfoForOfflineSyncForAllVehicles { result in
            switch result {
            case .success(let response):
                guard let data = response.data as? Data else {
                    completion(.failure(ApiResponseErrorBlock(message: "Invalid or missing data.")))
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(FuelDetailsResponseModel.self, from: data)
                    self.fuelDetailsResponseModel = decodedResponse

                    if let fuelList = decodedResponse.data {
                        for fuel in fuelList {
                            if let vehicleId = fuel.vehicleID {
                                if DatabaseHelper.shared.isFuelRecordExists(vehicleId: Int64(vehicleId)) {
                                    DatabaseHelper.shared.updateFuelInfo(fuel)
                                } else {
                                    DatabaseHelper.shared.insertFuelInfo(fuel)
                                }
                            }
                        }
                    } else {
                        print("No fuel data found.")
                    }

                    completion(.success(response))
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(ApiResponseErrorBlock(message: "Failed to parse response.")))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
}
