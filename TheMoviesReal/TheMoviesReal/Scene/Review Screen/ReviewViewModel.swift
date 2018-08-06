//
//  ReviewViewModel.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/6/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ReviewViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let error: Driver<Error>
        let indicator: Driver<Bool>
        let reviewList: Driver<[Review]>
        let reviewRate: Driver<Float>
        let reviewVoteCount: Driver<String>
        let posterUrl: Driver<String>
    }
    
    let useCase: ReviewUseCaseType
    let navigator: ReviewNavigatorType
    let movie: Movie
    
    func transform(_ input: ReviewViewModel.Input) -> ReviewViewModel.Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let reviewList = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getReviews(movieId: self.movie.id)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
        }
        
        let reviewRate = input.loadTrigger
            .map { _ in
                return self.movie.voteAverage
            }
        
        let reviewVoteCount = input.loadTrigger
            .map { _ in
                return "\(self.movie.voteCount) vote"
            }
        
        let posterUrl = input.loadTrigger
            .map { _ in
                return self.movie.posterPath
            }
        
        return Output(
            error: errorTracker.asDriver(),
            indicator: activityIndicator.asDriver(),
            reviewList: reviewList,
            reviewRate: reviewRate,
            reviewVoteCount: reviewVoteCount,
            posterUrl: posterUrl
        )
    }
}
