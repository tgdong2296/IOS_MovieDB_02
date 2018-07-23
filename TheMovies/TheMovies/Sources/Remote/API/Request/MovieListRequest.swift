//
//  MovieListRequest.swift
//  TheMovies
//
//  Created by Trịnh Giang Đông on 7/23/18.
//  Copyright © 2018 TrinhGiangDong. All rights reserved.
//

import Foundation

enum MovieListType {
    case nowPlaying
    case popular
    case topRated
    case upComing
}

class MovieListRequest: BaseRequest {
    required init(listType: MovieListType, page: Int) {
        let body: [String: Any]  = [
            "api_key": APIKey.key,
            "language": "en-US",
            "page": page
        ]
        var url = ""
        switch listType {
        case .nowPlaying:
            url = URLs.APIMovieNowPlayingURL
            
        case .popular:
            url = URLs.APIMoviePopularURL
            
        case .topRated:
            url = URLs.APIMovieTopRatedURL
            
        case .upComing:
            url = URLs.APIMovieUpcomingURL
        }
        super.init(url: url, requestType: .get, body: body)
    }
}
