//
//  Trailer.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/31/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class Trailer: BaseModel {
    var id: Int = 0
    var iso6391 = ""
    var iso3166 = ""
    var key = ""
    var name = ""
    var site = ""
    var size: Int = 0
    var type = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        iso6391 <- map["iso_639_1"]
        iso3166 <- map["iso_3166_1"]
        key <- map["key"]
        name <- map["name"]
        site <- map["site"]
        size <- map["size"]
        type <- map["type"]
    }
}
