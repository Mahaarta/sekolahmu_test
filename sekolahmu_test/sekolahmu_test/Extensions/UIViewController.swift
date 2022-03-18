//
//  UIViewController.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import UIKit
import Foundation

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // Initiate controller from Nib
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
}
