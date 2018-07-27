//
//  GenreDetailUseCase.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/27/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol GenreDetailUseCaseType {
    func getMovieList() -> Observable<PagingInfo<Movie>>
    func loadMoreMovieList(page: Int) -> Observable<PagingInfo<Movie>>
}

struct GenreDetailUseCase: GenreDetailUseCaseType {
    let genre: Genre
    
    func getMovieList() -> Observable<PagingInfo<Movie>> {
        return loadMoreMovieList(page: 1)
    }
    
    func loadMoreMovieList(page: Int) -> Observable<PagingInfo<Movie>> {
        let request = MovieByGenreRequest(genreId: genre.id,page: page)
        let movieRepository = MovieRepositoryImp(api: APIService.share)
        return movieRepository.getMovieByGenre(input: request)
            .map { movieList in
                return PagingInfo(page: page, items: movieList)
            }
    }
}
