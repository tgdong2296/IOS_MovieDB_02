//
//  ReviewRepository.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/6/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

protocol ReviewRepository {
    func getReviews(input: ReviewRequest) -> Observable<[Review]>
}

class ReviewRepositoryImp: ReviewRepository {
    private let api: APIService
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getReviews(input: ReviewRequest) -> Observable<[Review]> {
        return api.request(input: input)
            .map { (response: ReviewResponse) in
                return response.reviews
        }
    }
}
