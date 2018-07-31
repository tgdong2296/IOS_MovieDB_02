
//
//  Casr.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/31/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class Cast: BaseModel {
    var castId: Int = 0
    var character = ""
    var creditId = ""
    var gender: Int = 0
    var id: Int = 0
    var name = ""
    var order: Int = 0
    var profilePath = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        castId <- map["cast_id"]
        character <- map["character"]
        creditId <- map["credit_id"]
        gender <- map["gender"]
        id <- map["id"]
        name <- map["name"]
        order <- map["order"]
        profilePath <- map["profile_path"]
    }
}

