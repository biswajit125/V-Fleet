//
//  APIResultValidator.swift
//  iTechnolabs
//
//  Created by Kamaljeet Punia on 22/09/20.
//  Copyright © 2020 Kamaljeet Punia. All rights reserved.
//

import Foundation
//
//struct ApiResponseSuccessBlock{
//    var message: String
//    var statusCode: Int
//    var resultData: Any?
//}
//
//struct ApiResponseErrorBlock: Error {
//    var message: String
//  //  var statusCode: String
//}
//
//typealias ApiResponseCompletion = ((Result<ApiResponseSuccessBlock, ApiResponseErrorBlock>) -> ())
//typealias SocketResponseCompletion = ((Result<[String: Any], ApiResponseErrorBlock>) -> ())
//
//protocol APIResultValidatorApi{
//    func validateResponse(statusCode: Int, response: Any?, completionBlock: @escaping ApiResponseCompletion)
//    func getApiError(result:String?) -> ApiResponseErrorBlock
//    func getApiResponse(result:Any?, statusCode: Int) -> ApiResponseSuccessBlock
//}
//
//extension APIResultValidatorApi{
//    
//    func getApiError(result:String?) -> ApiResponseErrorBlock{
//        let apiError = ApiResponseErrorBlock.init(message: result ?? "Error description not available")
//        return apiError
//    }
//    
//    func getApiResponse(result:Any?, statusCode: Int) -> ApiResponseSuccessBlock{
//        var apiResponse = ApiResponseSuccessBlock.init(message: "", statusCode: statusCode, resultData: result)
//        if let responseDict = result as? [String:AnyObject] {
//            
//            if let msg = responseDict["msg"] as? String {
//                apiResponse.message = msg
//            }
//
//            apiResponse.resultData = responseDict as Any
//        }
//        return apiResponse
//    }
//}
//
//struct APIJSONResultValidator: APIResultValidatorApi{
//    
//    func validateResponse(statusCode: Int, response: Any?, completionBlock: @escaping ApiResponseCompletion) {
//
//        if statusCode == 200 || statusCode == 0  {
//            if let response = response  as? [String: Any] { //For response as dictionary
//                completionBlock(.success(self.getApiResponse(result: response, statusCode: statusCode)))
//            } else if let response = response as? [[String: Any]] { //For response as array of dictionary
//                completionBlock(.success(self.getApiResponse(result: response, statusCode: statusCode)))
//            } else {
//                completionBlock(.failure(self.getApiError(result: "Invalid JSON. Line: 61. Class: APIResultValidator")))
//            }
//        } else {
//            if let response = response  as? [String: Any] {
//                let message = response["msg"] as? String ?? LocalizedStringEnum.somethingWentWrong.localized
//                completionBlock(.failure(self.getApiError(result: message)))
//            }else {
//                completionBlock(.failure(self.getApiError(result: "Invalid JSON. Line: 69. Class: APIResultValidator")))
//            }
//        }
//    }
//}
//
//struct APIDataResultValidator: APIResultValidatorApi {
//    
//    func validateResponse(statusCode: Int, response: Any?, completionBlock: @escaping ApiResponseCompletion) {
//        
//        var jsonResponse: [String: Any]?
//        if let data = response as? Data {
//            do {
//                jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
//                debugPrint("API response is: ", jsonResponse ?? [:])
//            }catch {
//                debugPrint("Error converting data to JSON: ", error.localizedDescription)
//            }
//        }
//        
//        let responseStatusCode = (jsonResponse?["code"] as? Int) ?? 400
//        if statusCode == 200 && responseStatusCode == 200 {
//            var apiResponse = self.getApiResponse(result: jsonResponse, statusCode: statusCode)
//            apiResponse.resultData = response
//            completionBlock(.success(apiResponse))
//        } else if responseStatusCode == 401 || responseStatusCode == 403 || responseStatusCode == 400 {
//            if jsonResponse != nil {
//                let message = jsonResponse?["msg"] as? String ?? LocalizedStringEnum.somethingWentWrong.localized
//                if message == "Unauthorized"{
////                    let manager = FirebaseCloudFirestoreManager()
////                    manager.registerUserAs(online: false)
////
////                    RootControllerProxy.shared.setRoot(LoginVC.typeName , storyBoard: StoryBoard.main)
//                }else{
//                    completionBlock(.failure(self.getApiError(result: message)))
//                }
//            }else{
////                let manager = FirebaseCloudFirestoreManager()
////                manager.registerUserAs(online: false)
////
////                RootControllerProxy.shared.setRoot(LoginVC.typeName , storyBoard: StoryBoard.main)
//            }
//           
//        }else {
//            if jsonResponse != nil {
//                let message = jsonResponse?["msg"] as? String ?? LocalizedStringEnum.somethingWentWrong.localized
//                completionBlock(.failure(self.getApiError(result: message)))
//            }else {
//                completionBlock(.failure(self.getApiError(result: "Invalid JSON. Line: 101. Class: APIResultValidator")))
//            }
//        }
//    }
//    
//}
typealias JSONDictionary = [String:Any]
struct ApiResponseSuccessBlock {
    var message: String
    var status: Int
    var data: Any?
}

struct ApiResponseErrorBlock: Error {
    var message: String
}

typealias ApiResponseCompletion = ((Result<ApiResponseSuccessBlock, ApiResponseErrorBlock>) -> ())

protocol APIResultValidatorApi {
    func validateResponse(statusCode: Int, response: Any?, completionBlock: @escaping ApiResponseCompletion)
    func getApiError(result: String?) -> ApiResponseErrorBlock
    func getApiResponse(result: Any?, statusCode: Int) -> ApiResponseSuccessBlock
}

extension APIResultValidatorApi {
    func getApiError(result: String?) -> ApiResponseErrorBlock {
        return ApiResponseErrorBlock(message: result ?? "Error description not available")
    }

    func getApiResponse(result: Any?, statusCode: Int) -> ApiResponseSuccessBlock {
        var apiResponse = ApiResponseSuccessBlock(message: "", status: statusCode, data: result)
        if let responseDict = result as? [String: AnyObject],
           let msg = responseDict["msg"] as? String {
            apiResponse.message = msg
        }
        return apiResponse
    }
}

struct APIJSONResultValidator: APIResultValidatorApi {
    func validateResponse(statusCode: Int, response: Any?, completionBlock: @escaping ApiResponseCompletion) {
        if statusCode == 200 || statusCode == 0 {
            if let response = response as? [String: Any] {
                completionBlock(.success(self.getApiResponse(result: response, statusCode: statusCode)))
            } else if let response = response as? [[String: Any]] {
                completionBlock(.success(self.getApiResponse(result: response, statusCode: statusCode)))
            } 
            else {
                completionBlock(.failure(self.getApiError(result: "Invalid JSON. Line: 61. Class: APIResultValidator")))
            }
        } else {
            if let response = response as? [String: Any] {
                let message = response["msg"] as? String ?? "Something went wrong"
                completionBlock(.failure(self.getApiError(result: message)))
            } else {
                completionBlock(.failure(self.getApiError(result: "Invalid JSON. Line: 69. Class: APIResultValidator")))
            }
        }
    }
}

struct APIDataResultValidator: APIResultValidatorApi {
    func validateResponse(statusCode: Int, response: Any?, completionBlock: @escaping ApiResponseCompletion) {
        var jsonResponse: [String: Any]?
        if let data = response as? Data {
            do {
                jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                debugPrint("API response is4: ", jsonResponse ?? [:])
            } catch {
                debugPrint("Error converting data to JSON: ", error.localizedDescription)
                completionBlock(.failure(self.getApiError(result: "Error converting data to JSON")))
                return
            }
        }

        let responseStatusCode = (jsonResponse?["status"] as? Int) ?? 400
      
        if statusCode == 500 && responseStatusCode == 500 {
            var apiResponse = self.getApiResponse(result: jsonResponse, statusCode: statusCode)
            apiResponse.data = response
            completionBlock(.success(apiResponse))
        }
        if statusCode == 401 && responseStatusCode == 401 {
            var apiResponse = self.getApiResponse(result: jsonResponse, statusCode: statusCode)
            apiResponse.data = response
            completionBlock(.success(apiResponse))
        }
        if statusCode == 404 && responseStatusCode == 404 {
            var apiResponse = self.getApiResponse(result: jsonResponse, statusCode: statusCode)
            apiResponse.data = response
            print("response 404 :: ",response)
            completionBlock(.success(apiResponse))
        }
        if statusCode == 200 && responseStatusCode == 200 {
            var apiResponse = self.getApiResponse(result: jsonResponse, statusCode: statusCode)
            apiResponse.data = response
            completionBlock(.success(apiResponse))
        } else {
            let message = jsonResponse?["msg"] as? String ?? "Something went wrong"
            completionBlock(.failure(self.getApiError(result: message)))
        }
    }
}

//struct APIDataResultValidator: APIResultValidatorApi {
//    func validateResponse(statusCode: Int, response: Any?, completionBlock: @escaping ApiResponseCompletion) {
//        var jsonResponse: [String: Any]?
//        
//        if let data = response as? Data {
//            do {
//                jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
//                debugPrint("API response is4: ", jsonResponse ?? [:])
//            } catch {
//                debugPrint("Error converting data to JSON: ", error.localizedDescription)
//                completionBlock(.failure(self.getApiError(result: "Error converting data to JSON")))
//                return
//            }
//        }
//        
//        let responseStatusCode = (jsonResponse?["status"] as? Int) ?? 400
//        
//        //        // Handling 404 status
//        //        if statusCode == 404 && responseStatusCode == 404 {
//        //            var apiResponse = self.getApiResponse(result: jsonResponse, statusCode: statusCode)
//        //            apiResponse.data = response
//        //            completionBlock(.success(apiResponse))
//        //            return
//        //        }
//        
//        // Handling other statuses (500, 401, 200, etc.)
//        if [500, 401, 200,404].contains(statusCode) && statusCode == responseStatusCode {
//            var apiResponse = self.getApiResponse(result: jsonResponse, statusCode: statusCode)
//            apiResponse.data = response
//            completionBlock(.success(apiResponse))
//        } else {
//            let message = jsonResponse?["msg"] as? String ?? "Something went wrong"
//            completionBlock(.failure(self.getApiError(result: message)))
//        }
//    }
//}


//struct APIDataResultValidator: APIResultValidatorApi {
//    func validateResponse(statusCode: Int, response: Any?, completionBlock: @escaping ApiResponseCompletion) {
//        var jsonResponse: [String: Any]?
//        
//        if let data = response as? Data {
//            do {
//                jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
//                debugPrint("API response: ", jsonResponse ?? [:])
//            } catch {
//                debugPrint("Error converting data to JSON: ", error.localizedDescription)
//                completionBlock(.failure(self.getApiError(result: "Error converting data to JSON")))
//                return
//            }
//        }
//
//        let responseStatusCode = jsonResponse?["status"] as? Int ?? 400
//
//        if statusCode == responseStatusCode {
//            var apiResponse = self.getApiResponse(result: jsonResponse, statusCode: statusCode)
//            apiResponse.data = response
//            completionBlock(.success(apiResponse))
//        } else {
//            let message = jsonResponse?["msg"] as? String ?? "Something went wrong"
//            completionBlock(.failure(self.getApiError(result: message)))
//        }
//    }
//}

//struct APIDataResultValidator: APIResultValidatorApi {
//    func validateResponse(statusCode: Int, response: Any?, completionBlock: @escaping ApiResponseCompletion) {
//        var jsonResponse: [String: Any]?
//
//        if let data = response as? Data {
//            do {
//                // Attempt to decode the JSON response
//                jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
//                debugPrint("API response: ", jsonResponse ?? [:])
//            } catch {
//                // Handle JSON decoding error
//                debugPrint("Error decoding data to JSON: ", error.localizedDescription)
//                completionBlock(.failure(self.getApiError(result: "Error decoding data to JSON")))
//                return
//            }
//        } else {
//            debugPrint("Error: Response is not in expected Data format.")
//            completionBlock(.failure(self.getApiError(result: "Response is not in expected Data format.")))
//            return
//        }
//
//        // Check if status codes match
//        let responseStatusCode = jsonResponse?["status"] as? Int ?? 400
//        if statusCode == responseStatusCode {
//            var apiResponse = self.getApiResponse(result: jsonResponse, statusCode: statusCode)
//            apiResponse.data = response
//            completionBlock(.success(apiResponse))
//        } else {
//            let message = jsonResponse?["message"] as? String ?? "Something went wrong"
//            debugPrint("Error message from API: ", message)
//            completionBlock(.failure(self.getApiError(result: message)))
//        }
//    }
//}
