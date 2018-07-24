//
//  GenreListRequest.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/23/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

class GenreListRequest: BaseRequest {
    required init(listType: MovieListType, page: Int) {
        let body: [String: Any]  = [
            "api_key": APIKey.key,
            "language": "en-US"
        ]
        super.init(url: URLs.APIGenreListURL, requestType: .get, body: body)
    }
}
