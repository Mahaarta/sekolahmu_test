//
//  CommonHelper.swift
//  sekolahmu_test
//
//  Created by macbook on 18/03/22.
//

import UIKit
import Alamofire

class CommonHelper {
    
    // MARK: - Common Functions
    static let shared = CommonHelper()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    // Detect internet connection
    func isConnectedToInternet() -> Bool {
        let networkReachabilityManager = NetworkReachabilityManager()
        return networkReachabilityManager?.isReachable ?? false
    }
}
