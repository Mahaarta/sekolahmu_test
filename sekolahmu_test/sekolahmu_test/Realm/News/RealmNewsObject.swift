//
//  RealmNewsObject.swift
//  sekolahmu_test
//
//  Created by macbook on 21/03/22.
//

import Foundation
import RealmSwift

class RealmNewsObject: Object {
    @objc dynamic var abstract = ""
    @objc dynamic var web_url = ""
    @objc dynamic var snippet = ""
    @objc dynamic var lead_paragraph = ""
    @objc dynamic var print_section = ""
    @objc dynamic var print_page = ""
    @objc dynamic var source = ""
    @objc dynamic var type_of_material = ""
    @objc dynamic var _id = ""
    @objc dynamic var word_count = 0
    @objc dynamic var uri = ""
    @objc dynamic var headline_main = ""
    @objc dynamic var headline_kicker = ""
    @objc dynamic var headline_content_kicker = ""
    @objc dynamic var headline_print_headline = ""
    @objc dynamic var headline_name = ""
    @objc dynamic var headline_seo = ""
    @objc dynamic var headline_sub = ""
    @objc dynamic var thumbnail = ""
    @objc dynamic var detail_image = ""
    @objc dynamic var news_position = ""
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
