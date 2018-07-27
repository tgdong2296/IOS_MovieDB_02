//
//  GenreViewModel.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/24/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct GenreViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let selectGenreTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let genreList: Driver<[Genre]>
        let error: Driver<Error>
        let indicator: Driver<Bool>
        let selectedGenre: Driver<Void>
    }
    
    let navigator: GenreNavigatorType
    let useCase: GenreUseCaseType
    
    func transform(_ input: GenreViewModel.Input) -> GenreViewModel.Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        let genreList = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getGenreList()
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        let selectedGenre = input.selectGenreTrigger
            .withLatestFrom(genreList) { indexPath, genreList in
                return (indexPath, genreList)
            }.map{ (indexPath, genreList) in
                return genreList[indexPath.row]
            }.do(onNext: {genre in
                self.navigator.toGenreDetailScreen(genre: genre)
            })
            .mapToVoid()
        
        return Output(
            genreList: genreList,
            error: errorTracker.asDriver(),
            indicator: activityIndicator.asDriver(),
            selectedGenre: selectedGenre
        )
    }
}
