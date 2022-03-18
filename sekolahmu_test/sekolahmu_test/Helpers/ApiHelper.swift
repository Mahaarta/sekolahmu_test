//
//  ApiHelper.swift
//  sekolahmu_test
//
//  Created by macbook on 18/03/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwifterSwift
import Kingfisher

class ErrorObject: NSObject {
    var errorCode: String?
    var message: String
    var errorHandlerType: ErrorHandlerType
    
    init(errorCode: String?, message: String, errorHandlerType: ErrorHandlerType) {
        self.errorCode = errorCode
        self.message = message
        self.errorHandlerType = errorHandlerType
    }
}

enum ErrorHandlerType {
    case doNothing
    case showSnackbarOnly
    case backToPreviousPage
    case backToProductHomePage
    case backToRootPage
}

protocol ApiInterfaceDelegate: AnyObject {
    func onSuccess(interface: ApiInterface?, object: Any)
    func onFailed(interface: ApiInterface?, errorCode: String?, message: String, errorHandlerType: ErrorHandlerType)
}

protocol ApiInterface: AnyObject {
    var method: HTTPMethod? { get set }
    var url: URLConvertible { get set }
    var headers: HTTPHeaders? { get set }
    var parameters: Parameters? { get set }
    var encoding: ParameterEncoding? { get set }
    
    func start()
    func success(_ value: JSON)
    func failed(_ value: JSON?)
    func createObject(_ value: Any)
}

class ApiHelper {
    static let shared = ApiHelper()
    static var manager = setupSessionManager()
    
    // API Request header for authenticated user
    func authJsonHeader() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Token": "C4rB0N4r4",
            "Content-Type": "application/json",
            "Authorization": "Bearer Token"
        ]
        return headers
    }
    
    static func setupSessionManager(timeoutForRequest: Double = 300, timeoutForResource: Double = 300) -> SessionManager {
        let configuration = URLSessionConfiguration.default
        
        // Set Timeout
        configuration.timeoutIntervalForRequest = timeoutForRequest
        configuration.timeoutIntervalForResource = timeoutForResource
        
        return Alamofire.SessionManager(configuration: configuration)
    }
    
    static func setupDefaultHeader(headers: HTTPHeaders) -> HTTPHeaders {
        // Insert your common headers here, for example, authorization token or accept.
        var commonHeaders: [String: String] = [:]
        
        commonHeaders["Accept"] = "application/json, text/plain"
        commonHeaders["Token"] = "C4rB0N4r4"
        commonHeaders["Authorization"] = "Bearer Token"
        
        // Replace old value with new value
        commonHeaders.merge(headers) { (_, new) in new }
        
        return commonHeaders
    }
    
    static func apiRequest(api: ApiInterface) {
        // Insert your common headers here, for example, authorization token or accept.
        let allHeaders = ApiHelper.setupDefaultHeader(headers: api.headers ?? [:])
        
        if CommonHelper.shared.isConnectedToInternet() {
            ApiHelper.manager
                .requestWithoutCache(
                    api.url,
                    method: api.method ?? .get,
                    parameters: api.parameters,
                    encoding: api.encoding ?? URLEncoding.default,
                    headers: allHeaders
                )?
                .validate(statusCode: 200..<600)
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(_):

                        let request = response.request
                        let header = response.request?.allHTTPHeaderFields
                        let params = api.parameters
                        
                        //TODO: Uncomment if you want to see json response
                        #if !IS_PRODUCTION
                        print("statusCode: success \(response.response?.statusCode ?? -1)")
                        print(request ?? "")
                        print(JSON(header ?? [:]))
                        print(JSON(params ?? [:]))
                        print(response.result.value ?? JSON([:]))
                        #endif
                        
                        // Valid JSON Response
                        guard let value = response.result.value else {
                            // No Response Value
                            print("Default Error Message")
                            api.failed(nil)
                            return
                        }
                        
                        // Valid Success Response
                        api.success(JSON(value))
                    case .failure(let error):

                        let request = response.request
                        let header = response.request?.allHTTPHeaderFields
                        let params = api.parameters
                        
                        //TODO: Uncomment if you want to see json response
                        #if !IS_PRODUCTION
                        print("statusCode: failed \(response.response?.statusCode ?? -1)")
                        print(request ?? "")
                        print(JSON(header ?? [:]))
                        print(JSON(params ?? [:]))
                        print(response.result.value ?? JSON([:]))
                        print("StatusCode: \(response.response?.statusCode ?? 0)")
                        print("Error: \(error)")
                        #endif
                        
                        if response.response?.statusCode == 500 || response.response?.statusCode == 503 {
                            // Internet Lost, Service Unavailable, Internal Server Error
                            print("Internet Lost, Service Unavailable, Internal Server Error")
                            api.failed(nil)
                        } else if error._code == NSURLErrorTimedOut || response.response?.statusCode == 408 {
                            // RTO
                            print("Request Time Out")
                            api.failed(nil)
                        } else if error._code == NSURLErrorCancelled {
                            // Cancelled
                            print("Cancelled")
                            api.failed(["network_error": NSURLErrorCancelled])
                        } else {
                            // Valid JSON Response
                            guard let value = response.result.value else {
                                // No Response Value
                                print("Default Error Message")
                                api.failed(nil)
                                return
                            }
                            
                            // Valid Failed Response
                            api.failed(JSON(value))
                        }
                    }
                })
        } else {
            // Internet Lost, Service Unavailable, Internal Server Error
            print("Internet Lost, Service Unavailable, Internal Server Error")
            api.failed(nil)
        }
    }
}

extension Alamofire.SessionManager {
    
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil) // also you can add URLRequest.CachePolicy here as parameter
        -> DataRequest? {
            do {
                var urlRequest = try URLRequest(url: url, method: method, headers: headers)
                urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
                let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
                return request(encodedURLRequest)
            } catch {
                // TODO: find a better way to handle error
                print(error)
                
                guard let url = "http://example.com/wrong_request".url else { return nil }
                return request(URLRequest(url: url))
            }
    }
    
}
