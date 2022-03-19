//
//  NetworkErrorViewController.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import UIKit

class NetworkErrorViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var bigTitleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    // variables
    var isConnectedToInternet = CommonHelper.shared.isConnectedToInternet()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bigTitleLabel.text = "Network Error"
        descLabel.text = "Unable to contact the server"
        logoImageView.image = UIImage(named: "no-internet")
        logoImageView.contentMode = .scaleAspectFit
    }
}
