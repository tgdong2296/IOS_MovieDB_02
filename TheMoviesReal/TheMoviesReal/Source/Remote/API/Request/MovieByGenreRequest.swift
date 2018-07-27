//
//  MovieByGenreRequest.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/27/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

class MovieByGenreRequest: BaseRequest {
    required init(genreId: Int, page: Int) {
        let body: [String: Any]  = [
            "api_key": APIKey.key,
            "language": "en-US",
            "page": page
        ]
        let url = URLs.APIMovieByGenreURL + "\(genreId)/movies"
        super.init(url: url, requestType: .get, body: body)
    }
}
