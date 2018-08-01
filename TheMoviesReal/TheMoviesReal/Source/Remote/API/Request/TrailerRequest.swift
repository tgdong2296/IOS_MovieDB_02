//
//  TrailerRequest.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/31/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

class TrailerRequest: BaseRequest {
    required init(movieId id: Int) {
        let body: [String: Any]  = [
            "api_key": APIKey.key,
            "language": "en-US"
        ]
        let url = URLs.APITrailerURL + "\(id)/videos"
        super.init(url: url, requestType: .get, body: body)
    }
}
