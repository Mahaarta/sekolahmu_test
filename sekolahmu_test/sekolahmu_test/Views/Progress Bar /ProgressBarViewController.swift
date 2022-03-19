//
//  ProgressBarViewController.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import UIKit

protocol progressBarDelegate {
    func progressBar(done: Bool)
}

class ProgressBarViewController: UIViewController {
    @IBOutlet weak var progressIndicator: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingView()
    }
    
    func settingView() {
        progressLabel.text = "Please wait.."
        
        // stop any current animation
        self.progressIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }
        
        // reset progressIndicator to 100%
        self.progressIndicator.setProgress(1.0, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // set progressIndicator to 0%, with animated set to false
            self.progressIndicator.setProgress(0.0, animated: false)
            // 10-second animation changing from 100% to 0%
            UIView.animate(withDuration: 10, delay: 0, options: [], animations: { [unowned self] in
                self.progressIndicator.layoutIfNeeded()
            })
        }
    }
}
