//
//  GenreUseCase.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/24/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol GenreUseCaseType {
    func getGenreList() -> Observable<[Genre]>
}

struct GenreUseCase: GenreUseCaseType {
    func getGenreList() -> Observable<[Genre]> {
        let request = GenreListRequest()
        let repository = GenreRepositoryImp(api: APIService.share)
        return repository.getGenreList(input: request)
    }
}
