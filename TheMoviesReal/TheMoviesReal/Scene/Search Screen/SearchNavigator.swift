//
//  SearchNavigator.swift
//  TheMoviesReal
//
//  Created by Hai on 7/29/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import UIKit

protocol SearchNavigatorType {
    func toSearchScreen()
    func toMovieDetail(movie: Movie)
}

struct SearchNavigator: SearchNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toSearchScreen() {
        let searchViewController = SearchViewController.instantiate()
        let searchViewModel = SearchViewModel(navigator: self, useCase: SearchUseCase())
        searchViewController.bindViewModel(to: searchViewModel)
        navigationController.pushViewController(searchViewController, animated: true)
    }
    
    func toMovieDetail(movie: Movie) {
        let navigator = MovieDetailNavigator(navigationController: navigationController)
        navigator.toMovieDetail(movie: movie)
    }
}
