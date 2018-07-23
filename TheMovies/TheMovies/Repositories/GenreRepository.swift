//
//  GenreRepository.swift
//  TheMovies
//
//  Created by Trịnh Giang Đông on 7/23/18.
//  Copyright © 2018 TrinhGiangDong. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

protocol GenreRepository {
    func getGenreList(input: GenreListRequest) -> Observable<[Genre]>
}

class GenreRepositoryImp: GenreRepository {
    private var api: APIService!
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getGenreList(input: GenreListRequest) -> Observable<[Genre]> {
        return api.request(input: input).map { (response: GenreListResponse) -> [Genre] in
            return response.genreList
        }
    }
}
