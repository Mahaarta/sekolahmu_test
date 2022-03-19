//
//  ArticleRequest.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ArticleRequestDelegate: AnyObject {
    func ArticleRequestSuccess(_ articleList: ArticleList)
    func ArticleRequestFailed(_ message: String)
}

class ArticleRequest: ApiInterface {
    var method: HTTPMethod?
    
    var url: URLConvertible
    
    var headers: HTTPHeaders?
    
    var parameters: Parameters?
    
    var encoding: ParameterEncoding?
    
    var requestHandler: ArticleRequestDelegate?
    
    // MARK: Inits
    required init() {
        method = .get
        url = Endpoints.News.article.url
    }
    
    func start() {
        ApiHelper.apiRequest(api: self)
    }
    
    func prepare(query: String, requestHandler: ArticleRequestDelegate) {
        self.requestHandler = requestHandler
        
        parameters = [
            "q": query,
            "api-key": Constants.APIKey
        ]
    }
    
    func success(_ value: JSON) {
        if !value.isEmpty {
            print("dalam123")
            createObject(value["response"])
        } else {
            failed(value)
        }
    }
    
    func failed(_ value: JSON?) {
        requestHandler?.ArticleRequestFailed(value?["message"].stringValue ?? Constants.defaultErrorMessage)
    }
    
    func createObject(_ value: Any) {
        guard let json = value as? JSON else { return }
        if let dict = json.dictionaryObject, let response = ArticleList(JSON: dict) {
            requestHandler?.ArticleRequestSuccess(response)
        } else {
            failed(nil)
        }
    }
}
