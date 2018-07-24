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
        return Output(
            genreList: genreList,
            error: errorTracker.asDriver(),
            indicator: activityIndicator.asDriver()
        )
    }
}
