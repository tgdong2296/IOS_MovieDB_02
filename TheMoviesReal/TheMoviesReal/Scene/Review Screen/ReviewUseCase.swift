//
//  ReviewUseCase.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/6/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift

protocol ReviewUseCaseType {
    func getReviews(movieId id: Int) -> Observable<[Review]>
}

struct ReviewUseCase: ReviewUseCaseType {
    func getReviews(movieId id: Int) -> Observable<[Review]> {
        let request = ReviewRequest(movieID: id, page: 1)
        let repository = ReviewRepositoryImp(api: APIService.share)
        return repository.getReviews(input: request)
            .filter { reviews in
                reviews.count > 0
            }
    }
}
