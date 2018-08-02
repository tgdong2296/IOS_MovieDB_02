//
//  SearchUseCase.swift
//  TheMoviesReal
//
//  Created by Hai on 7/29/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchUseCaseType {
    func getMovieList(query: String) -> Observable<PagingInfo<Movie>>
    func loadMoreMovieList(query: String, page: Int) -> Observable<PagingInfo<Movie>>
}

struct SearchUseCase: SearchUseCaseType {
    func getMovieList(query: String) -> Observable<PagingInfo<Movie>> {
        return loadMoreMovieList(query: query, page: 1)
    }
    
    func loadMoreMovieList(query: String, page: Int) -> Observable<PagingInfo<Movie>> {
        let request = MovieSearchRequest(query: query, page: page)
        let repository = MovieRepositoryImp(api: APIService.share)
        return repository.getMovieListSearch(input: request)
            .map { movieList in
                return PagingInfo(page: page, items: movieList)
        }
    }
}
