//
//  PersonCreditResponse.swift
//  TheMoviesReal
//
//  Created by Hai on 8/7/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class PersonCreditResponse: BaseModel {
    var casts = [Movie]()
    var crews = [Movie]()
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        casts <- map["cast"]
        crews <- map["crew"]
    }
}
