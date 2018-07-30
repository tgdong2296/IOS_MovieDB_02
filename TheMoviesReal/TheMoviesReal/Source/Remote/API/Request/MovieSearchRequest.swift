//
//  MovieSearchRequest.swift
//  TheMoviesReal
//
//  Created by Hai on 7/30/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

class MovieSearchRequest: BaseRequest {
    required init(query: String, page:Int) {
        let body: [String: Any] = [
            "api_key": APIKey.key,
            "language": "en-US",
            "query" : query,
            "page": page
        ]
        super .init(url: URLs.APIMovieSearch , requestType: .get, body: body)
    }
}
