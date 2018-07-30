//
//  MovieTypeUseCase.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/28/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieTypeUseCaseType {
    func getMovieList(listType: MovieListType) -> Observable<PagingInfo<Movie>>
    func loadMoreMovieList(listType: MovieListType, page: Int) -> Observable<PagingInfo<Movie>>
}

struct MovieTypeUseCase: MovieTypeUseCaseType {
    func getMovieList(listType: MovieListType) -> Observable<PagingInfo<Movie>> {
        return loadMoreMovieList(listType: listType, page: 1)
    }
    
    func loadMoreMovieList(listType: MovieListType, page: Int) -> Observable<PagingInfo<Movie>> {
        let request = MovieListRequest(listType: listType, page: page)
        let repository = MovieRepositoryImp(api: APIService.share)
        return repository.getMovieList(input: request)
            .map { movieList in
                return PagingInfo(page: page, items: movieList)
            }
    }
}
