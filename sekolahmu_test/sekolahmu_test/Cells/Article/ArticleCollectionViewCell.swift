//
//  ArticleCollectionViewCell.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import UIKit

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
            let imageURL = URL(string: "\(Endpoints.News.thumbnail.url)/\(thumbnail)")
            articleImageView.kf.setImage(with: imageURL)
            articleImageView.contentMode = .scaleAspectFill
        } else {
            articleImageView.image = UIImage(named: "image-default")
            articleImageView.contentMode = .scaleAspectFill
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
