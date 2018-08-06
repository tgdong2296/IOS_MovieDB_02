//
//  ReviewResponse.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/6/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class ReviewResponse: BaseModel {
    var id = 0
    var page = 0
    var reviews = [Review]()
    var totalPage = 0
    var totalResults = 0
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        page <- map["page"]
        reviews <- map["results"]
        totalPage <- map["total_pages"]
        totalResults <- map["total_results"]
    }
}
