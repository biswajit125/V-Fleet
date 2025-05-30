//
//  AuthenticationApiServicesEndPoints.swift
//  Shepherd Cares
//
//  Created by itechnolabs on 25/04/22.
//

import UIKit

fileprivate enum AuthenticationApiServicesEndPoints: APIService {
    //Define cases according to API's
    case login(_ parameters: [String: Any])
    case addSaveAttendance(_ parameters: [String: Any])
    case startStopShift(_ parameters: [String: Any])
    case getVehicleInfoAtRefueling(vehicleId: Int)
    case postFuelDetails(userId: String,_ parameters: [String: Any])
    case getVehicleByVehicleNumber(vehicleNumber: String,compId: Int)
    case addExpenseDetails(_ parameters: [String: Any])
    case getAttendanceReportByUser(userId: Int)
    case upload(_ parameters: [String: Any])
    case uploadImg
    case getPrevMileage(vehicleId: Int, currentMileage: Double)
    case getUserData
    case getAllVehicleDetails
    case getFuelInfoForOfflineSyncForAllVehicles
    
    //Return path according to api case
    var path: String {
        switch self {
        case .login(let params):
            var components = URLComponents(string: AppConstants.Urls.apiBaseUrl + "api/mobile/user/loginMobile")!
                       components.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                       return components.url!.absoluteString
            
        case .addSaveAttendance(_):
            return AppConstants.Urls.apiBaseUrl + "api/mobile/attendance/addSaveAttendance"
            
        case .startStopShift:
            return AppConstants.Urls.apiBaseUrl + "api/mobile/shift/startStopShift"
            
        case .getVehicleInfoAtRefueling(let vehicleId):
            return AppConstants.Urls.apiBaseUrl + "api/mobile/fuel/getInstantVehicleInfoAtRefueling?vehicleId=\(vehicleId)"
            
        case .postFuelDetails(let userId, _):
                    return AppConstants.Urls.apiBaseUrl + "api/mobile/fuel/postFuelDetails?userId=\(userId)"
        case .getVehicleByVehicleNumber(let vehicleNumber,let compId):
            return AppConstants.Urls.apiBaseUrl + //"api/mobile/vehicle/getVehicleByVehicleNumber?vehicleNumber=\(vehicleNumber)"
            "api/mobile/vehicle/getVehicleByVehicleNumberAndCompany?vehicleNumber=\(vehicleNumber)&compId=\(compId)"
            
        case .addExpenseDetails(_):
            return AppConstants.Urls.apiBaseUrl + "api/mobile/expense/addExpenseDetails"
            
        case .getAttendanceReportByUser(let userId):
            return AppConstants.Urls.apiBaseUrl + "api/mobile/attendance/getAttendanceReportByUser?userId=\(userId)"
            
        case .upload(_):
            return AppConstants.Urls.apiBaseUrl + "api/mobile/upload/addFile"
            
        case .uploadImg:
            return AppConstants.Urls.apiBaseUrl + "api/mobile/upload/addFile"
        case .getPrevMileage(let vehicleId, let currentMileage):
            return AppConstants.Urls.apiBaseUrl + "api/mobile/fuel/getPrevMileage?vehicleId=\(vehicleId)&currentMileage=\(currentMileage)"
            
        case .getUserData:
//            http://45.64.222.18:8083/fleet-mate-v3/
            let url = AppConstants.Urls.apiBaseUrl + "api/mobile/user/getAllUsers"
//            let url = "http://45.64.222.18:8083/fleet-mate-v3/" + "api/mobile/user/getAllUsers"
            return url
            
        case .getAllVehicleDetails:
               return AppConstants.Urls.apiBaseUrl + "api/mobile/vehicle/getAllVehicleDetails"
        case .getFuelInfoForOfflineSyncForAllVehicles:
            return AppConstants.Urls.apiBaseUrl + "api/mobile/fuel/getFuelInfoForOfflineSyncForAllVehicles"
        }
    }
    
    //Return resource according to api case
    var resource: Resource {
        let headers: [String: Any] = [
            "Content-Type": "application/json"
        ]
        let _: [String: Any] = [
            "Content-Type": "application/json",
         //   "Authorization": "Bearer \(AppCache.shared.token)"
        ]
        
        switch self {
        case .login(let params) ,.addSaveAttendance(let params),.startStopShift(let params) ,.postFuelDetails(_, let params) :
            return Resource(method: .post, parameters: params, encoding: .QUERY, headers: headers, validator: APIDataResultValidator(), responseType: .data)
        case .getVehicleInfoAtRefueling(_):
            return Resource(method: .get, parameters: nil, encoding: .QUERY, headers: headers, validator: APIDataResultValidator(), responseType: .data)
            
        case .getVehicleByVehicleNumber(_):
            return Resource(method: .get, parameters: nil, encoding: .QUERY, headers: headers, validator: APIDataResultValidator(), responseType: .data)
        case .addExpenseDetails(let params):
            return Resource(method: .post, parameters: params, encoding: .QUERY, headers: headers, validator: APIDataResultValidator(), responseType: .data)
            
        case .getAttendanceReportByUser(_):
            return Resource(method: .get, parameters: nil, encoding: .QUERY, headers: headers, validator: APIDataResultValidator(), responseType: .data)
            
        case .upload(_):
            return Resource(method: .post, parameters: nil, encoding: .QUERY, headers: headers, validator: APIDataResultValidator(), responseType: .data)
            
        case .uploadImg:
            return Resource(method: .post, parameters: nil, encoding: .JSONENCODING, headers: nil, validator: APIJSONResultValidator(), responseType: .json)
        case .getPrevMileage:
            return Resource(method: .get, parameters: nil, encoding: .QUERY, headers: headers, validator: APIDataResultValidator(), responseType: .data)
        
        case .getUserData:
            return Resource(method: .get, parameters: nil, encoding: .QUERY, headers: headers, validator: APIDataResultValidator(), responseType: .data)
        case .getAllVehicleDetails:
                return Resource(method: .get, parameters: nil, encoding: .QUERY, headers: headers, validator: APIDataResultValidator(), responseType: .data)
        case .getFuelInfoForOfflineSyncForAllVehicles:
            return Resource(method: .get,parameters: nil,encoding: .QUERY, headers: headers,validator: APIDataResultValidator(),responseType: .data)
        }
        
    }
}

    struct AuthenticationApiServices {
        
        func login(_ parameters: [String: Any], completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.login(parameters).urlRequest(completionBlock: completionBlock)
        }
        func addSaveAttendance(_ parameters: [String: Any], completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.addSaveAttendance(parameters).urlRequest(completionBlock: completionBlock)
        }
        func startStopShift(_ parameters: [String: Any], completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.startStopShift(parameters).urlRequest(completionBlock: completionBlock)
        }
        
        func getVehicleInfoAtRefueling( vehicleId: Int, completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.getVehicleInfoAtRefueling(vehicleId: vehicleId).urlRequest(completionBlock: completionBlock)
        }
        
        func postFuelDetails(userId: String, parameters: [String: Any], completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.postFuelDetails(userId: userId, parameters).urlRequest(completionBlock: completionBlock)
        }
        
        func getVehicleByVehicleNumber(vehicleNumber: String,compId: Int, completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.getVehicleByVehicleNumber(vehicleNumber: vehicleNumber, compId: compId).urlRequest(completionBlock: completionBlock)
        }
        
        func getAllUserDetails(completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.getUserData.urlRequest(completionBlock: completionBlock)
        }
        
        
//        func addExpenseDetails(_ parameters: [String: Any], multipartModelArray: [MultipartModel] ,completionBlock: @escaping ApiResponseCompletion) {
//            AuthenticationApiServicesEndPoints.addExpenseDetails(parameters).requestMultipart(modelArray: multipartModelArray, uploadType: .data, completionBlock: completionBlock)
//        }
        
        func addExpenseDetails(_ parameters: [String: Any],completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.addExpenseDetails(parameters).urlRequest(completionBlock: completionBlock)
        }
        
        func getAttendanceReportByUser(userId: Int, completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.getAttendanceReportByUser(userId: userId).urlRequest(completionBlock: completionBlock)
        }
        
        func upload(_ parameters: [String: Any], multipartModelArray: [MultipartModel] ,completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.upload(parameters).requestMultipart(modelArray: multipartModelArray, uploadType: .data, completionBlock: completionBlock)
        }
        
        func uploadImg(_ imageDict: [String: Data], completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.uploadImg.requestImgMultipart(imageDict: imageDict, completionBlock: completionBlock)
        }
        func getPrevMileage(vehicleId: Int, currentMileage: Double, completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.getPrevMileage(vehicleId: vehicleId, currentMileage: currentMileage).urlRequest(completionBlock: completionBlock)
        }
        func getAllVehicleDetails(completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.getAllVehicleDetails.urlRequest(completionBlock: completionBlock)
        }
        func getFuelInfoForOfflineSyncForAllVehicles(completionBlock: @escaping ApiResponseCompletion) {
            AuthenticationApiServicesEndPoints.getFuelInfoForOfflineSyncForAllVehicles.urlRequest(completionBlock: completionBlock)
        }
        
    }


