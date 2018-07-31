//
//  MovieCreditResponse.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/31/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieCreditResponse: BaseModel {
    var id: Int = 0
    var casts = [Cast]()
    var crews = [Crew]()
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        casts <- map["cast"]
        crews <- map["crew"]
    }
}
