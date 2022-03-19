//
//  UICollectionView.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import UIKit
import SnapKit
import Foundation

extension UICollectionView {
    func restore() {
        self.backgroundView = nil
    }
    
    // Set empty message for CollectionView
    func setEmptyMessage(_ message: String) {
        let view = UIView()
        
        let messageLabel = UILabel()
        
        messageLabel.text = message
        messageLabel.textColor = UIColor(hexString: "b2bec3")
        messageLabel.numberOfLines = 1;
        messageLabel.textAlignment = .left;
        messageLabel.font = UIFont(name: "Helvatica", size: 13)
        messageLabel.sizeToFit()

        self.backgroundView = view
        self.backgroundView?.addSubview(messageLabel)
        
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
