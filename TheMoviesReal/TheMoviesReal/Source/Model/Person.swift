//
//  Person.swift
//  TheMoviesReal
//
//  Created by Hai on 8/5/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class Person: BaseModel {
    var birthday = Date()
    var job = ""
    var deathday = ""
    var id = 0
    var name = ""
    var knownAs = [String]()
    var gender = 0
    var biography = ""
    var popularity = 0.0
    var birthPlace = ""
    var prolifePath = ""
    var adult = false
    var imbdId = ""
    var homepage = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        birthday <- map["birthday"]
        job <- map["known_for_department"]
        deathday <- map["deathday"]
        id <- map["id"]
        name <- map["name"]
        knownAs <- map["also_known_as"]
        gender <- map["gender"]
        biography <- map["biography"]
        popularity <- map["popularity"]
        birthPlace <- map["place_of_birth"]
        prolifePath <- map["profile_path"]
        adult <- map["adult"]
        imbdId <- map["imdb_id"]
        homepage <- map["homepage"]
    }
}
