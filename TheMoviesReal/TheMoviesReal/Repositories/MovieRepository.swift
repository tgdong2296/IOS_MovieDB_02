//
//  MovieRepository.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/23/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

protocol MovieRepository {
    func getMovieList(input: MovieListRequest) -> Observable<[Movie]>
    func getMovieDetail(input: MovieDetailRequest) -> Observable<Movie>
}

class MovieRepositoryImp: MovieRepository {
    private var api: APIService!
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getMovieList(input: MovieListRequest) -> Observable<[Movie]> {
        return api.request(input: input).map { (response: MovieListResponse) -> [Movie] in
            return response.movieList
        }
    }
    
    func getMovieDetail(input: MovieDetailRequest) -> Observable<Movie> {
        return api.request(input: input).map { (response: Movie) -> Movie in
            return response
        }
    }
}
