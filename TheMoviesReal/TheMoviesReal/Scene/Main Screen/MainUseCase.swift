//
//  MainUseCase.swift
//  TheMoviesReal
//
//  Created by Hai on 7/26/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainUseCaseType {
    func getMovieList(listType: MovieListType) -> Observable<[Movie]>
    func getBannerList(listType: MovieListType) -> Observable<[Movie]>
}

struct MainUseCase: MainUseCaseType {
    func getMovieList(listType: MovieListType) -> Observable<[Movie]> {
        let request = MovieListRequest(listType: listType, page: 1)
        let repository = MovieRepositoryImp(api: APIService.share)
        return repository.getMovieList(input: request)
    }
    
    func getBannerList(listType: MovieListType) -> Observable<[Movie]> {
        let request = MovieListRequest(listType: listType, page: 1)
        let repository = MovieRepositoryImp(api: APIService.share)
        return repository.getMovieList(input: request)
            .map { movies in
                return Array(movies.prefix(7))
            }
    }
}
