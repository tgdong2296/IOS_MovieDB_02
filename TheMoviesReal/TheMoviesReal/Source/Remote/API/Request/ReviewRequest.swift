//
//  ReviewRequest.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/6/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

class ReviewRequest: BaseRequest {
    required init(movieID: Int, page: Int) {
        let body: [String: Any] = [
            "api_key": APIKey.key,
            "language": "en-US",
            "page": page
        ]
        let url = URLs.APIReviewURL + "\(movieID)/reviews"
        super .init(url: url, requestType: .get, body: body)
    }
}
