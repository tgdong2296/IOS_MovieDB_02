//
//  URLs.swift
//  TheMovies
//
//  Created by Trịnh Giang Đông on 7/23/18.
//  Copyright © 2018 TrinhGiangDong. All rights reserved.
//

import Foundation

struct URLs {
    private static let APIBaseUrl = "https://api.themoviedb.org"
    
    static let APIMovieNowPlayingURL = APIBaseUrl + "/3/movie/now_playing"
    
    static let APIMoviePopularURL = APIBaseUrl + "/3/movie/popular"
    
    static let APIMovieTopRatedURL = APIBaseUrl + "/3/movie/top_rated"
    
    static let APIMovieUpcomingURL = APIBaseUrl + "/3/movie/upcoming"
    
    static let APIGenreListURL = APIBaseUrl + "/3/genre/movie/list"
    
    static let APIMovieDetailURL = APIBaseUrl + "/3/movie/"
}
