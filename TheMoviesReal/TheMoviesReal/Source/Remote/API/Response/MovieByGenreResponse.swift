//
//  MovieByGenreResponse.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/27/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieByGenreResponse: BaseModel {
    var id: Int = 0
    var page: Int = 0
    var movieList = [Movie]()
    var totalPage: Int = 0
    var totalResult: Int = 0
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        page <- map["page"]
        movieList <- map["results"]
        totalPage <- map["total_pages"]
        totalResult <- map["total_results"]
    }
}
