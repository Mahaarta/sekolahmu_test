//
//  ArticleCollectionViewCell.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import UIKit
import Kingfisher

class ArticleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    // Weather online data
    var article: Article? {
        didSet {
            guard let article = article else { return }
            
            getArchiveThumbnail(multimedia: article.multimedia)
            titleLabel.text = article.headline_main
            descLabel.text = article.abstract
        }
    }
    
    // Get thumbnail photo
    func getArchiveThumbnail(multimedia: [Multimedia]) {
        let thumbnail = multimedia.filter { $0.subtype == "thumbnail" }.first?.url
        
        if let thumbnail = thumbnail {
            settingCacheImage(URLString: "\(Endpoints.News.thumbnail.url)/\(thumbnail)")
            retrieveCacheImage(URLString: "\(Endpoints.News.thumbnail.url)/\(thumbnail)")
        } else {
            articleImageView.image = UIImage(named: "image-default")
            articleImageView.contentMode = .scaleAspectFill
        }
        
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
        
        // Memory image expires after 10 minutes.
        cache.memoryStorage.config.expiration = .days(2)

        // Disk image never expires.
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
            let processor = DownsamplingImageProcessor(size: articleImageView.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 8)
            articleImageView.kf.indicatorType = .activity
            articleImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "image-default"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ], completionHandler:
                    {
                        result in
                        switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                        }
                    })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.numberOfLines = 2
        descLabel.numberOfLines = 3
        
        articleImageView.cornerRadius = 12
        
        mainContainer.cornerRadius = 12
        mainContainer.addShadow(ofColor: .lightGray, radius: 3.0, offset: CGSize.zero, opacity: 0.6)
        mainContainer.layer.shadowOffset = CGSize(width: 0 , height: 3)
    }

}
