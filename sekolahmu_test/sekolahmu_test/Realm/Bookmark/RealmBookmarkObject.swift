//
//  RealmBookmarkObject.swift
//  sekolahmu_test
//
//  Created by macbook on 20/03/22.
//

import Foundation
import RealmSwift

class RealmBookmarkObject: Object {
    @objc dynamic var _id = ""
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
