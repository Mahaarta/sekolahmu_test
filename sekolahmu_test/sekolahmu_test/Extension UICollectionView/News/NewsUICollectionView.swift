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
        let articleData = self.arrArticle?.count
        
        if (articleData ?? 0 == 0) {
            self.colView.setEmptyMessage("No News Found")
        } else {
            self.colView.restore()
        }
        
        return articleData ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArticleCollectionViewCell.self), for: indexPath) as! ArticleCollectionViewCell
        cell.article = self.arrArticle?[safe: indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: colView.width-16-16, height: 127)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = NewsDetailViewController.loadFromNib()
        vc.article = self.arrArticle?[safe: indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
