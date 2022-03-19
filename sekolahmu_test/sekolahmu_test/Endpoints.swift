//
//  Endpoints.swift
//  sekolahmu_test
//
//  Created by macbook on 18/03/22.
//

import Foundation

private protocol Endpoint {
    var url: String { get }
}

private struct Api {
    static let baseUrlProd = "https://api.nytimes.com/svc"
    static let baseUrlDev = "https://api.nytimes.com/svc"
    static let baseUrlImage = "https://www.nytimes.com"
    
    #if IS_PRODUCTION
    static let baseUrl = baseUrlProd
    #else
    static let baseUrl = baseUrlDev
    #endif
}


enum Endpoints {
    enum News: Endpoint {
        case archive
        case article
        case thumbnail
        
        public var url: String {
            switch self {
            case .archive: return "\(Api.baseUrl)/archive/v1"
            case .article: return "\(Api.baseUrl)/search/v2/articlesearch.json"
            case .thumbnail: return "\(Api.baseUrlImage)"
            }
        }
    }
}
