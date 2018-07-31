//
//  TrailerRepository.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/31/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

protocol TrailerRepository {
    func getTrailers(input: TrailerRequest) -> Observable<[Trailer]>
}

class TrailerRepositoryImp: TrailerRepository {
    private var api: APIService!
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getTrailers(input: TrailerRequest) -> Observable<[Trailer]> {
        return api.request(input: input)
            .map { (response: TrailerResponse) in
                return response.trailers
        }
    }
}
