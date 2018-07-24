//
//  MovieListResponse.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/23/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieListResponse: BaseModel {
    var movieList = [Movie]()
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        movieList <- map["results"]
    }
}
