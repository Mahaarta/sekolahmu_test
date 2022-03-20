//
//  ProgressBarViewController.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import UIKit

protocol ProgressBarDelegate {
    func progressBar(done: Bool)
}

class ProgressBarViewController: UIViewController {
    @IBOutlet weak var progressIndicator: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    // Register delegate
    var progressBarDelegate: ProgressBarDelegate!
    // is done
    var done = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad12")
        if done { settingView() }
        self.progressLabel.text = "Please wait.."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        progressIndicator.setProgress(0.97, animated: true)
    }
    
    func settingView() {
        self.progressBarDelegate.progressBar(done: true)
    }
}
