//
//  Crew.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/31/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class Crew: BaseModel {
    var creditId = ""
    var department = ""
    var gender: Int = 0
    var id: Int = 0
    var job = ""
    var name = ""
    var profilePath = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        creditId <- map["credit_id"]
        department <- map["department"]
        gender <- map["gender"]
        id <- map["id"]
        job <- map["job"]
        name <- map["name"]
        profilePath <- map["profile_path"]
    }
}
