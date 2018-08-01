//
//  MovieDetailUseCase.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/30/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MovieDetailUseCaseType {
    func getDetailMovie(movie: Movie) -> Observable<Movie>
    func getCast(movieId id: Int) -> Observable<[Cast]>
    func getCrew(movieId id: Int) -> Observable<[Crew]>
    func getTrailer(movieId id: Int) -> Observable<String>
}

struct MovieDetailUseCase: MovieDetailUseCaseType {
    func getDetailMovie(movie: Movie) -> Observable<Movie> {
        let request = MovieDetailRequest(movieId: movie.id)
        let repository = MovieRepositoryImp(api: APIService.share)
        return repository.getMovieDetail(input: request)
    }
    
    func getCast(movieId id: Int) -> Observable<[Cast]> {
        let request = MovieCreditRequest(movieId: id)
        let repository = CreditRepositoryImp(api: APIService.share)
        return repository.getCredit(input: request)
            .map { creditResponse in
                return creditResponse.casts
            }
    }
    
    func getCrew(movieId id: Int) -> Observable<[Crew]> {
        let request = MovieCreditRequest(movieId: id)
        let repository = CreditRepositoryImp(api: APIService.share)
        return repository.getCredit(input: request)
            .map { creditResponse in
                return creditResponse.crews
            }
    }
    
    func getTrailer(movieId id: Int) -> Observable<String> {
        let request = TrailerRequest(movieId: id)
        let repository = TrailerRepositoryImp(api: APIService.share)
        return repository.getTrailers(input: request)
            .map { trailers in
                return trailers[0].key
            }
    }
}
