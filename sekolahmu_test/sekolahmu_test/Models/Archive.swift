//
//  Archive.swift
//  sekolahmu_test
//
//  Created by macbook on 18/03/22.
//

import Foundation
import ObjectMapper

class Archive: Mappable {
    var abstract = ""
    var web_url = ""
    var snippet = ""
    var source = ""
    var headline_main = ""
    var headline_kicker = ""
    var headline_content_kicker = ""
    var headline_print_headline = ""
    var headline_name = ""
    var headline_seo = ""
    var headline_sub = ""
    var multimedia: [Multimedia] = []

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        abstract <- map["abstract"]
        web_url <- map["web_url"]
        snippet <- map["snippet"]
        source <- map["source"]
        headline_main <- map["headline.main"]
        headline_kicker <- map["headline.kicker"]
        headline_content_kicker <- map["headline.content_kicker"]
        headline_print_headline <- map["headline.print_headline"]
        headline_name <- map["headline.name"]
        headline_seo <- map["headline.seo"]
        headline_sub <- map["headline.sub"]
        multimedia <- map["multimedia"]
    }
}
