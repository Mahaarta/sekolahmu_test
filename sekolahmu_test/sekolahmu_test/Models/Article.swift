//
//  Article.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import Foundation
import ObjectMapper

class Article: Mappable {
    var abstract = ""
    var web_url = ""
    var snippet = ""
    var lead_paragraph = ""
    var print_section = ""
    var print_page = ""
    var source = ""
    var type_of_material = ""
    var _id = ""
    var word_count = 0
    var uri = ""
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
        lead_paragraph <- map["lead_paragraph"]
        print_section <- map["print_section"]
        print_page <- map["print_page"]
        source <- map["source"]
        type_of_material <- map["type_of_material"]
        _id <- map["_id"]
        word_count <- map["word_count"]
        uri <- map["uri"]
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

class ArticleList: Mappable {
    
    var currentPage = 0
    var from = 0
    var lastPage = 0
    var perPage = 0
    var to = 0
    var total = 0
    var arrArticle: [Article] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        currentPage <- map["meta.current_page"]
        from <- map["meta.from"]
        lastPage <- map["meta.last_page"]
        perPage <- map["meta.per_page"]
        to <- map["meta.to"]
        total <- map["meta.total"]
        arrArticle <- map["docs"]
    }
    
}
