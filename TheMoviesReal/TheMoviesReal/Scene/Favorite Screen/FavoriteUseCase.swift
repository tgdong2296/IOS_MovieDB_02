//
//  FavoriteUseCase.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/1/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol FavoriteUseCaseType {
    func getAllMovie() -> Observable<[Movie]>
    func deleteMovie(movie: Movie) -> Observable<DatabaseResultState>
}

struct FavoriteUseCase: FavoriteUseCaseType {
    func getAllMovie() -> Observable<[Movie]> {
        let database = DatabaseManager.sharedInstance()
        return database.getAllMovie()
    }
    
    func deleteMovie(movie: Movie) -> Observable<DatabaseResultState> {
        let database = DatabaseManager.sharedInstance()
        return database.delete(movie: movie)
    }
}
