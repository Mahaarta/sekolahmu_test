//
//  Multimedia.swift
//  sekolahmu_test
//
//  Created by macbook on 18/03/22.
//

import Foundation
import ObjectMapper

class Multimedia: Mappable {
    var rank = 0
    var subtype = ""
    var caption = ""
    var credit = ""
    var type = ""
    var url = ""
    var height = 0
    var width = 0
    var subType = "0"
    var crop_name = ""
    var legacy_xlarge = ""
    var legacy_xlargewidth = 0
    var legacy_xlargeheight = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        rank <- map["rank"]
        subtype <- map["subtype"]
        caption <- map["caption"]
        credit <- map["credit"]
        type <- map["type"]
        url <- map["url"]
        height <- map["height"]
        width <- map["width"]
        subType <- map["subType"]
        crop_name <- map["crop_name"]
        legacy_xlarge <- map["legacy.xlarge"]
        legacy_xlargewidth <- map["legacy.xlargewidth"]
        legacy_xlargeheight <- map["legacy.xlargeheight"]
        
    }
}
