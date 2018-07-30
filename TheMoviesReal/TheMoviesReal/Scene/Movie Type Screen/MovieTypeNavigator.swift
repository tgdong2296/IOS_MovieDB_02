//
//  MovieTypeNavigator.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/28/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit

protocol MovieTypeNavigatorType {
    func toMovieTypeScreen(listType: MovieListType)
    func toMovieDetail(movie: Movie)
}

struct MovieTypeNavigator: MovieTypeNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toMovieTypeScreen(listType: MovieListType) {
        let viewController = MovieTypeViewForMainController.instantiate()
        viewController.title = listType.rawValue
        let useCase = MovieTypeUseCase()
        let viewModel = MovieTypeViewModel(navigator: self, useCase: useCase, listType: listType)
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toMovieDetail(movie: Movie) {
        let navigator = MovieDetailNavigator(navigationController: navigationController)
        navigator.toMovieDetail(movie: movie)
    }
}
