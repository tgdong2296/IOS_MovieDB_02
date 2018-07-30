//
//  MainNavigator.swift
//  TheMoviesReal
//
//  Created by Hai on 7/26/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import UIKit

protocol MainNavigatorType {
    func toGenres()
    func toSearch()
    func toMovieDetail(movie: Movie)
    func toMovieTypeScreen(listType: MovieListType)
}

struct MainNavigator: MainNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toGenres() {
        let navigator = GenreNavigator(navigationController: navigationController)
        navigator.toGenreScreen()
    }
    
    func toSearch() {
        let navigator = SearchNavigator(navigationController: navigationController)
        navigator.toSearchScreen()
    }
    
    func toMovieDetail(movie: Movie) {
        let navigator = MovieDetailNavigator(navigationController:  navigationController)
        navigator.toMovieDetail(movie: movie)
    }
    
    func toMovieTypeScreen(listType: MovieListType) {
        let navigator = MovieTypeNavigator(navigationController: navigationController)
        navigator.toMovieTypeScreen(listType: listType)
    }
}
