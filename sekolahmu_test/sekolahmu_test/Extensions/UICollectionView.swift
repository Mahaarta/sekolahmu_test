//
//  UICollectionView.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import UIKit

extension UICollectionViewCell {
    // Register collection for collectionView
    static func register(for collectionView: UICollectionView)  {
        let cellName = String(describing: self)
        let cellIdentifier = cellName
        let cellNib = UINib(nibName: String(describing: self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
}
