//
//  NewsDetailViewController.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import Hero
import UIKit
import EzPopup
import Kingfisher
import RealmSwift

class NewsDetailViewController: UIViewController, ProgressBarDelegate {
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var pageIndicatorLabel: UILabel!
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
    var arrArticle: [Article]?
    // Variables
    var newsIndex = 0
    var newsCount = 0
    var isConnectedToInternet = CommonHelper.shared.isConnectedToInternet()
    // Realm results
    var resultRealmNewsObject: Results<RealmNewsObject>?
    var resultRealmBookmarkObject: Results<RealmBookmarkObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.hero.isEnabled = true
        self.navigationController?.hero.isEnabled = true
        
        settingHero()
        settingSwipeGesture()
        
        if !isConnectedToInternet {
            settingViewNoInternet()
            settingView()
            retrieveArticleOfflineData()
            
        } else {
            settingView()
            retrieveArticleOnlineData()
        }
    }
    
    // Setting view
    func settingView() {
        let articleOnline = self.arrArticle?.count
        let articleOffline = self.resultRealmNewsObject?.count
        newsCount = articleOnline ?? articleOffline ?? 0
        
        articleImageView.cornerRadius = 12
        shareContainer.cornerRadius = shareContainer.height / 2
        backContainer.cornerRadius = backContainer.height / 2
        backContainer.borderWidth = 1
        backContainer.borderColor = UIColor(hexString: "CCCCCC")
        
        shareButton.addShadow(ofColor: .lightGray, radius: 2.0, offset: CGSize.zero, opacity: 0.3)
        shareButton.layer.shadowOffset = CGSize(width: 0 , height: 2)
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
    
    // Setting view no internet
    func settingViewNoInternet() {
        let networkError = NetworkErrorViewController.loadFromNib()
        
        let popupVC = PopupViewController(
            contentController: networkError,
            position: .center(CGPoint(x: 0, y: 0)),
            popupWidth: UIScreen.main.bounds.width-40-40,
            popupHeight: 210
        )
        
        popupVC.cornerRadius = 24
        popupVC.canTapOutsideToDismiss = true
        self.present(popupVC, animated: true, completion: nil)
    }
    
    // Setting up hero id
    func settingHero() {
        let articleOnline = self.arrArticle?[safe: newsIndex]
        let articleOffline = self.resultRealmNewsObject?[safe: newsIndex]
        
        self.articleImageView.hero.id = "image-\(articleOnline?._id ?? articleOffline?._id ?? "")"
        self.mainContainer.hero.id = "container-\(articleOnline?._id ?? articleOffline?._id ?? "")"
        self.titleLabel.hero.id = "title-\(articleOnline?._id ?? articleOffline?._id ?? "")"
    }
    
    // Retrieve article online data
    func retrieveArticleOnlineData() {
        guard let article = arrArticle?[safe: newsIndex] else {
            settingProgressBarView(done: true)
            showAlert(title: "", message: Constants.defaultErrorMessage)
            return
        }

        self.settingProgressBarView(done: true)
        self.fadeIn()
        self.pageIndicatorLabel.text = "(\(self.newsIndex + 1)/\(self.newsCount))"
        
        titleLabel.text = article.headline_main
        descUITextView.text = article.lead_paragraph
        retrieveImageData(image: article.multimedia.filter { $0.subtype == "blog480" }.first?.url ?? "")
        
        print("bookmak \(article._id) == \(restoreBookmarkID()))")
        
        if article._id != restoreBookmarkID() {
            bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
    }
    
    // Retrieve article offline data
    func retrieveArticleOfflineData() {
        guard let article = self.resultRealmNewsObject?[safe: newsIndex] else {
            settingProgressBarView(done: true)
            showAlert(title: "", message: Constants.defaultErrorMessage)
            return
        }

        self.settingProgressBarView(done: true)
        self.fadeIn()
        self.pageIndicatorLabel.text = "(\(self.newsIndex + 1)/\(self.newsCount))"
        
        titleLabel.text = article.headline_main
        descUITextView.text = article.lead_paragraph
        retrieveImageData(image: article.detail_image)
        
        if article._id != restoreBookmarkID() {
            bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
    }
    
    // Retrieve image data
    func retrieveImageData(image: String) {
        if image != "" {
            settingCacheImage(URLString: "\(Endpoints.News.thumbnail.url)/\(image)")
            retrieveCacheImage(URLString: "\(Endpoints.News.thumbnail.url)/\(image)")
        } else {
            articleImageView.image = UIImage(named: "image-default")
        }
        
        articleImageView.contentMode = .scaleAspectFill
    }
    
    // Restore local bookmark data
    func restoreBookmarkID() -> String {
        let realm = try! Realm()
        self.resultRealmBookmarkObject = realm.objects(RealmBookmarkObject.self)
        
        let articleOnline = self.arrArticle?[safe: newsIndex]
        let articleOffline = self.resultRealmNewsObject?[safe: newsIndex]
        let localBookmarkID = self.resultRealmBookmarkObject?.filter { $0._id == (articleOnline?._id ?? articleOffline?._id ?? "") }.first
        
        return localBookmarkID?._id ?? ""
    }
    
    // setting up image from cache
    func settingCacheImage(URLString: String) {
        guard let photo_url = URL(string: URLString) else { return }
        let photoResource = ImageResource(downloadURL: photo_url)
        
        KingfisherManager.shared.retrieveImage(
            with: photoResource,
            options: nil,
            progressBlock: nil,
            completionHandler: { image, error, cacheType, imageURL in
            print("meData.photo_url local ")
        })
    }
    
    // Retrieve image from cache
    func retrieveCacheImage(URLString: String) {
        let url = URL(string: URLString)
        let cache = ImageCache.default
        let cached = cache.isCached(forKey: url?.absoluteString ?? "")
        let _ = cache.imageCachedType(forKey: url?.absoluteString ?? "")
        
        // Memory image expiration
        cache.memoryStorage.config.expiration = .days(2)

        // Disk image expiration
        cache.diskStorage.config.expiration = .days(2)
        
        if cached {
            cache.retrieveImage(forKey: url?.absoluteString ?? "") { result in
                switch result {
                case .success(let value):
                    
                    print("GET IMAGE FROM CACHE")
                    print("cache type \(value.cacheType)")
                    
                    self.articleImageView.image = value.image

                case .failure(let error):
                    print("caching fail")
                    print(error)
                }
            }
            
        } else {
            print("GET IMAGE FROM URL AND SET TO CACHE")
            let processor = DownsamplingImageProcessor(size: articleImageView.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 12)
            articleImageView.kf.indicatorType = .activity
            articleImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "image-default"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ],
                completionHandler: {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
            )
        }
    }
    
    // Setting up swipe gesture
    func settingSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeDown)
    }
    
    // Saving to local storage
    func savingLocalBookmark(id: String) {
        do {
            let realm = try Realm()
            try realm.write {
                let bookmark_obj = RealmBookmarkObject()
                bookmark_obj._id = id
                
                realm.add(bookmark_obj, update: .modified)
                
                self.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
        } catch let error as NSError{
            print("adding data to Realm error = \(error)")
        }
    }
    
    // Protocol delegate - From ProgressBarViewController
    func progressBar(done: Bool) {
        if done {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Animations
    /// Fade in
    func fadeIn() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.mainContainer.alpha = 1.0
        }, completion: nil)
    }
    
    /// Fade out
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.mainContainer.alpha = 0.0
        }, completion: nil)
    }

    //MARK: Action
    /// Back
    @IBAction func backButton_tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Bookmar
    @IBAction func bookmarkButton_tapped(_ sender: Any) {
        let articleOnline = self.arrArticle?[safe: newsIndex]
        let articleOffline = self.resultRealmNewsObject?[safe: newsIndex]


        savingLocalBookmark(id: articleOnline?._id ?? articleOffline?._id ?? "")
    }
    
    /// Share
    @IBAction func shareButton_tapped(_ sender: Any) {
        guard let article = self.arrArticle?[safe: newsIndex] else {
            let message = isConnectedToInternet ? Constants.defaultNetworkErrorMessage : Constants.defaultErrorMessage
            showAlert(title: "", message: message)
            return
        }
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndImageContext()
        
        let textToShare = article.headline_main
        
        if let myWebsite = URL(string: article._id) {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    /// Swipe gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                
                if (newsIndex - 1) >= 0 {
                    newsIndex -= 1
                    self.fadeOut()
                    isConnectedToInternet ? self.retrieveArticleOnlineData() : self.retrieveArticleOfflineData()
                }
                    
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left \(newsIndex)")
                
                if (newsIndex + 1) < newsCount {
                    newsIndex += 1
                    self.fadeOut()
                    isConnectedToInternet ? self.retrieveArticleOnlineData() : self.retrieveArticleOfflineData()
                }
                
            default:
                break
            }
        }
    }
}
