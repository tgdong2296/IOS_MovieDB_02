//
//  FavoriteViewModel.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/1/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

struct FavoriteViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let selectItemTrigger: Driver<IndexPath>
        let deleteTrigger: Driver<IndexPath>
        let editTrigger: Driver<Void>
    }
    
    struct Output {
        let error: Driver<Error>
        let indicator: Driver<Bool>
        let favoriteList: Driver<[Movie]>
        let editAction: Driver<Void>
        let selectedMovie: Driver<Void>
        let deletedMovie: Driver<Void>
        let isEmpty: Driver<Bool>
    }
    
    let navigator: FavoriteNavigatorType
    let useCase: FavoriteUseCaseType
    
    func transform(_ input: FavoriteViewModel.Input) -> FavoriteViewModel.Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let movieList = input.loadTrigger
            .flatMapLatest {
                return self.useCase.getAllMovie()
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let selectedMovie = input.selectItemTrigger
            .withLatestFrom(movieList) { indexPath, movieList in
                return (indexPath, movieList)
            }
            .map { indexPath, movieList in
                return movieList[indexPath.row]
            }
            .do(onNext: { movie in
                self.navigator.toMovieDetail(movie: movie)
            })
            .mapToVoid()
        
        let deletedMovie = input.deleteTrigger
            .withLatestFrom(movieList) { indexPath, movieList in
                return movieList[indexPath.row]
            }
            .flatMapLatest { movie in
                return self.navigator.confirmDelete(movie: movie)
                    .map { movie }
            }
            .flatMapLatest { movie in
                return self.useCase.deleteMovie(movie: movie)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .filter { result in
                result == .deleteSucess
            }
            .mapToVoid()
        
        let editAction = input.editTrigger
        
        let isEmptyData = Driver.combineLatest(movieList, activityIndicator.asDriver())
            .filter { element in
                !element.1
            }
            .map { element in
                element.0.isEmpty
        }
        
        return Output(
            error: errorTracker.asDriver(),
            indicator: activityIndicator.asDriver(),
            favoriteList: movieList,
            editAction: editAction,
            selectedMovie: selectedMovie,
            deletedMovie: deletedMovie,
            isEmpty: isEmptyData
        )
    }
}
