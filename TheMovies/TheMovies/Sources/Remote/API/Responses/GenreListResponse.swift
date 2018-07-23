//
//  GenreListResponse.swift
//  TheMovies
//
//  Created by Trịnh Giang Đông on 7/23/18.
//  Copyright © 2018 TrinhGiangDong. All rights reserved.
//

import Foundation
import ObjectMapper

class GenreListResponse: BaseModel {
    var genreList = [Genre]()
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        genreList <- map["genres"]
    }
}
