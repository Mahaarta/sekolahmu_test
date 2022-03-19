//
//  NewsDetailViewController.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import Hero
import UIKit
import EzPopup

class NewsDetailViewController: UIViewController, ProgressBarDelegate {
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var backContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var detailNewsLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var shareContainer: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var descUITextView: UITextView!
    // Article
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.hero.isEnabled = true
        self.navigationController?.hero.isEnabled = true
        
        settingHero()
        settingView()
        retrieveArticleData()
    }
    
    // Setting view
    func settingView() {
        articleImageView.cornerRadius = 12
        shareContainer.cornerRadius = shareContainer.height / 2
        
        backContainer.cornerRadius = backContainer.height / 2
        backContainer.borderWidth = 1
        backContainer.borderColor = UIColor(hexString: "CCCCCC")
    }
    
    // Call progressBar indicator
    func settingProgressBarView(done: Bool) {
        let progressBarPop = ProgressBarViewController.loadFromNib()
        progressBarPop.done = done
        progressBarPop.progressBarDelegate = self
        
        let popupVC = PopupViewController(
            contentController: progressBarPop,
            position: .center(CGPoint(x: 0, y: 0)),
            popupWidth: UIScreen.main.bounds.width-32-32,
            popupHeight: 150
        )
        
        popupVC.cornerRadius = 24
        popupVC.canTapOutsideToDismiss = false
        
        if !done { self.present(popupVC, animated: true, completion: nil); print("8888") }
    }
    
    // Setting up hero id
    func settingHero() {
        self.articleImageView.hero.id = "image-\(self.article?._id ?? "")"
        self.mainContainer.hero.id = "container-\(self.article?._id ?? "")"
        self.titleLabel.hero.id = "title-\(self.article?._id ?? "")"
    }
    
    // Retrieve article data
    func retrieveArticleData() {
        //settingProgressBarView(done: false)
        
        guard let article = article else {
            settingProgressBarView(done: true)
            showAlert(title: "", message: Constants.defaultErrorMessage)
            return
        }

        settingProgressBarView(done: true)
        
        titleLabel.text = article.headline_main
        descUITextView.text = article.lead_paragraph
        retrieveImageData(multimedia: article.multimedia)
    }
    
    // Retrieve image data
    func retrieveImageData(multimedia: [Multimedia]) {
        let thumbnail = multimedia.filter { $0.subtype == "blog480" }.first?.url
        
        if let thumbnail = thumbnail {
            let imageURL = URL(string: "\(Endpoints.News.thumbnail.url)/\(thumbnail)")
            articleImageView.kf.setImage(with: imageURL)
            articleImageView.contentMode = .scaleAspectFill
        } else {
            articleImageView.image = UIImage(named: "image-default")
            articleImageView.contentMode = .scaleAspectFill
        }
    }
    
    // Protocol delegate - From ProgressBarViewController
    func progressBar(done: Bool) {
        if done {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Button Action
    @IBAction func backButton_tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookmarkButton_tapped(_ sender: Any) {
    }
    
    @IBAction func shareButton_tapped(_ sender: Any) {
        guard let article = self.article else {
            showAlert(title: "", message: Constants.defaultErrorMessage)
            return
        }
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndImageContext()
        
        let textToShare = article.headline_main
        
        if let myWebsite = URL(string: article._id) {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
