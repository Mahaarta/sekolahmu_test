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
}
