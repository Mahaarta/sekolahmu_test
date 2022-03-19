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
        
        self.progressLabel.text = "Please wait.."
        self.progressIndicator.setProgress(0.35, animated: true)
        
        if done { settingView() }
    }
    
    func settingView() {
        print("udah belom \(done)")
        self.progressIndicator.setProgress(1.0, animated: true)
        progressBarDelegate.progressBar(done: true)
    }
}
