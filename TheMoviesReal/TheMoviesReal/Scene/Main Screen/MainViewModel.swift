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
        let toMovieTypeTrigger: Driver<MovieListType>
        let toSearchTrigger: Driver<Void>
        let toMovieDetailTrigger: Driver<Movie>
        let bannerSelectTrigger: Driver<Int>
    }
    
    struct Output {
        let movieListPopular: Driver<[Movie]>
        let movieListNowPlaying: Driver<[Movie]>
        let movieListUpcoming: Driver<[Movie]>
        let movieListTopRated: Driver<[Movie]>
        let bannerList: Driver<[Movie]>
        let bannerSelected: Driver<Void>
        let error: Driver<Error>
        let indicator: Driver<Bool>
        let toSearch: Driver<Void>
        let toMovieType: Driver<Void>
        let toMovieDetail: Driver<Void>
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
        
        let toSearchAction = input.toSearchTrigger
            .do(onNext: { _ in
                self.navigator.toSearch()
            })
        
        let toMovieType = input.toMovieTypeTrigger
            .map { self.navigator.toMovieTypeScreen(listType: $0)}
        
        let toMovieDetail = input.toMovieDetailTrigger
            .map { self.navigator.toMovieDetail(movie: $0)}

        let bannerList = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getBannerList()
                    .trackError(errortracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        let bannerSelected = input.bannerSelectTrigger
            .withLatestFrom(bannerList) { index, banners in
                return banners[index]
            }
            .do(onNext: { movie in
                self.navigator.toMovieDetail(movie: movie)
            })
            .mapToVoid()
        
        return Output(
            movieListPopular: movieListPopular,
            movieListNowPlaying: movieListNowPlaying,
            movieListUpcoming: movieListUpcoming,
            movieListTopRated: movieListTopRated,
            bannerList: bannerList,
            bannerSelected: bannerSelected,
            error: errortracker.asDriver(),
            indicator: activityIndicator.asDriver(),
            toSearch: toSearchAction,
            toMovieType: toMovieType,
            toMovieDetail: toMovieDetail
        )
    }
}
