//
//  MainViewModel.swift
//  TheMoviesReal
//
//  Created by Hai on 7/26/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct MainViewModel: ViewModelType {
    struct  Input {
        let loadTrigger: Driver<Void>
        let cellButtonTrigger: Driver<Void>
    }
    
    struct Output {
        let movieListPopular: Driver<[Movie]>
        let movieListNowPlaying: Driver<[Movie]>
        let movieListUpcoming: Driver<[Movie]>
        let movieListTopRated: Driver<[Movie]>
        let error: Driver<Error>
        let indicator: Driver<Bool>
    }
    
    let navigator: MainNavigatorType
    let useCase: MainUseCaseType
    
    func transform(_ input: MainViewModel.Input) -> MainViewModel.Output {
        let errortracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        let movieListPopular = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getMovieList(listType: .popular)
                    .trackError(errortracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
        }
        let movieListNowPlaying = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getMovieList(listType: .nowPlaying)
                    .trackError(errortracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
        }
        let movieListUpcoming = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getMovieList(listType: .upComing)
                    .trackError(errortracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
        }
        let movieListTopRated = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getMovieList(listType: .topRated)
                    .trackError(errortracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
        }
        return Output(
            movieListPopular: movieListPopular,
            movieListNowPlaying: movieListNowPlaying,
            movieListUpcoming: movieListUpcoming,
            movieListTopRated: movieListTopRated,
            error: errortracker.asDriver(),
            indicator: activityIndicator.asDriver()
        )
    }
}
