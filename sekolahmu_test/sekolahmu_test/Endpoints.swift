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
    
    #if IS_PRODUCTION
    static let baseUrl = baseUrlProd
    #else
    static let baseUrl = baseUrlDev
    #endif
}


enum Endpoints {
    enum News: Endpoint {
        case archive
        
        public var url: String {
            switch self {
            case .archive: return "\(Api.baseUrl)/archive/v1"
            }
        }
    }
}
