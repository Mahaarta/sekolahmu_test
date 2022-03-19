//
//  ArchiveCollectionViewCell.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import UIKit

class ArchiveCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    // Weather online data
    var article: Article? {
        didSet {
            guard let article = article else { return }
            
            print("MANAH \(article.headline_seo)")
            getArchiveThumbnail(multimedia: article.multimedia)
            titleLabel.text = article.headline_seo
            descLabel.text = article.abstract
        }
    }
    
    // Get thumbnail photo
    func getArchiveThumbnail(multimedia: [Multimedia]) {
        if let imageUrl = URL(string: multimedia.filter { $0.subtype == "thumbnail" }.first?.url ?? "" ) {
            newsImageView.kf.setImage(with: imageUrl)
            newsImageView.contentMode = .scaleAspectFill
        } else {
            newsImageView.image = UIImage(named: "image-default")
            newsImageView.contentMode = .scaleAspectFill
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
