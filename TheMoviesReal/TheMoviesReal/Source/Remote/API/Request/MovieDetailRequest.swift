//
//  MovieDetailRequest.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/23/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

class MovieDetailRequest: BaseRequest {
    required init(movieId id: Int) {
        let body: [String: Any]  = [
            "api_key": APIKey.key,
            "language": "en-US"
        ]
        let url = URLs.APIMovieDetailURL + "\(id)"
        super.init(url: url, requestType: .get, body: body)
    }
}
