//
//  PersonCreditsRequest.swift
//  TheMoviesReal
//
//  Created by Hai on 8/7/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

class PersonCreditRequest: BaseRequest {
    required init(personId id: Int) {
        let body: [String: Any] = [
            "api_key": APIKey.key,
            "language": "en-US"
        ]
        let url = URLs.APIPerson + "\(id)/movie_credits"
        super.init(url: url, requestType: .get, body: body)
    }
}
