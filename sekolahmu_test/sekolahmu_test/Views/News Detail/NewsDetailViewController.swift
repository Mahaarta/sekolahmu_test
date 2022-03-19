//
//  NewsDetailViewController.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import UIKit

class NewsDetailViewController: UIViewController {
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
    
    // Retrieve article data
    func retrieveArticleData() {
        guard let article = article else {
            showAlert(title: "", message: Constants.defaultErrorMessage)
            return
        }

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
    
    //MARK: Button Action
    @IBAction func backButton_tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookmarkButton_tapped(_ sender: Any) {
    }
    
    @IBAction func shareButton_tapped(_ sender: Any) {
    }
}
