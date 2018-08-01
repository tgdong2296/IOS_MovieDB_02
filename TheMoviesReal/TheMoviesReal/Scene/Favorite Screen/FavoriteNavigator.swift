//
//  FavoriteNavigator.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/1/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import UIKit

protocol FavoriteNavigatorType {
    func toMovieDetail(movie: Movie)
}

struct FavoriteNavigator: FavoriteNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toMovieDetail(movie: Movie) {
        let navigator = MovieDetailNavigator(navigationController: navigationController)
        navigator.toMovieDetail(movie: movie)
    }
}
