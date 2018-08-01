//
//  MovieDetailViewModel.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/30/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MovieDetailViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let seeMoreTrigger: Driver<Void>
    }
    
    struct Output {
        let error: Driver<Error>
        let activityIndicator: Driver<Bool>
        let youtubeViewOutput: Driver<String>
        let movieName: Driver<String>
        let movieRate: Driver<Float>
        let movieStatus: Driver<String>
        let movieDuration: Driver<String>
        let moviePoster: Driver<String>
        let movieOverview: Driver<String>
        let castList: Driver<[Cast]>
        let crewList: Driver<[Crew]>
        let overviewState: Driver<Bool>
    }
    
    let navigator: MovieDetailNavigatorType
    let useCase: MovieDetailUseCaseType
    let movie: Movie
    
    func transform(_ input: MovieDetailViewModel.Input) -> MovieDetailViewModel.Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        let stateSeeMore = BehaviorRelay(value: false)
        
        let overviewState = input.seeMoreTrigger
            .withLatestFrom(stateSeeMore.asDriver())
            .map { state -> Bool in
                stateSeeMore.accept(!state)
                return !state
            }
        
        let youtubeView = input.loadTrigger
            .flatMapLatest {
                return self.useCase.getTrailer(movieId: self.movie.id)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        let castList = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getCast(movieId: self.movie.id)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        let crewList = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getCrew(movieId: self.movie.id)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        let detail = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getDetailMovie(movie: self.movie)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let movieName = input.loadTrigger
            .map { movie in
                return self.movie.title
            }
        
        let movieRate = detail
            .map { movie in
                return movie.voteAverage
            }
        
        let movieStatus = detail
            .map { movie in
                return movie.status
            }
        
        let movieDuration = detail
            .map { movie in
                return "\(movie.runtime) min"
            }
        
        let moviePoster = detail
            .map { movie in
                return movie.posterPath
            }
        
        let movieOverview = detail
            .map { movie in
                return movie.overview
            }
        
        return Output(
            error: errorTracker.asDriver(),
            activityIndicator: activityIndicator.asDriver(),
            youtubeViewOutput: youtubeView,
            movieName: movieName,
            movieRate: movieRate,
            movieStatus: movieStatus,
            movieDuration: movieDuration,
            moviePoster: moviePoster,
            movieOverview: movieOverview,
            castList: castList,
            crewList: crewList,
            overviewState: overviewState.asDriver()
        )
    }
}
