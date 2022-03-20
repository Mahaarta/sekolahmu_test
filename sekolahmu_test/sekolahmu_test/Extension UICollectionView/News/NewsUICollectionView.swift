//
//  NewsUICollectionView.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import UIKit
import Foundation

// MARK: COLLECTION SETTING
extension NewsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let articleOnline = self.arrArticle?.count
        let articleOffline = self.resultRealmNewsObject?.count
        
        if (articleOnline ?? articleOffline ?? 0 == 0) {
            self.colView.setEmptyMessage("No News Found")
        } else {
            self.colView.restore()
        }
        
        return articleOnline ?? articleOffline ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let articleOnline = self.arrArticle?[safe: indexPath.item]
        let articleOffline = self.resultRealmNewsObject?[safe: indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArticleCollectionViewCell.self), for: indexPath) as! ArticleCollectionViewCell
        cell.article = articleOnline
        cell.realmNewsObject = articleOffline
        cell.articleImageView.hero.id = "image-\(articleOnline?._id ?? articleOffline?._id ?? "")"
        cell.mainContainer.hero.id = "container-\(articleOnline?._id ?? articleOffline?._id ?? "")"
        cell.titleLabel.hero.id = "title-\(articleOnline?._id ?? articleOffline?._id ?? "")"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: colView.width-16-16, height: 127)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = NewsDetailViewController.loadFromNib()
        vc.arrArticle = self.arrArticle
        vc.resultRealmNewsObject = self.resultRealmNewsObject
        vc.newsIndex = indexPath.item
        self.navigationController?.hero.navigationAnimationType = .selectBy(presenting: .fade, dismissing: .fade)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
