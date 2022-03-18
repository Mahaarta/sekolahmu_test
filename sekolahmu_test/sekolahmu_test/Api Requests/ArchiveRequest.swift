//
//  ArchiveRequest.swift
//  sekolahmu_test
//
//  Created by macbook on 18/03/22.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ArchiveRequestDelegate: AnyObject {
    func ArchiveRequestSuccess(_ archiveList: ArchiveList)
    func ArchiveRequestFailed(_ message: String)
}

class ArchiveRequest: ApiInterface {
    var method: HTTPMethod?
    
    var url: URLConvertible
    
    var headers: HTTPHeaders?
    
    var parameters: Parameters?
    
    var encoding: ParameterEncoding?
    
    var requestHandler: ArchiveRequestDelegate?
    
    // MARK: Inits
    required init() {
        method = .get
        url = Endpoints.News.archive.url
    }
    
    func start() {
        ApiHelper.apiRequest(api: self)
    }
    
    func prepare(requestHandler: ArchiveRequestDelegate) {
        self.requestHandler = requestHandler
        
        parameters = [:]
    }
    
    func success(_ value: JSON) {
        print("value json \(value.isEmpty) === \(!value.isEmpty)")
        if !value["response"].isEmpty {
            createObject(value)
        } else {
            failed(value)
        }
    }
    
    func failed(_ value: JSON?) {
        requestHandler?.ArchiveRequestFailed(value?["message"].stringValue ?? Constants.defaultErrorMessage)
    }
    
    func createObject(_ value: Any) {
        guard let json = value as? JSON else { return }
        if let dict = json.dictionaryObject, let response = ArchiveList(JSON: dict) {
            requestHandler?.ArchiveRequestSuccess(response)
        } else {
            failed(nil)
        }
    }
}
