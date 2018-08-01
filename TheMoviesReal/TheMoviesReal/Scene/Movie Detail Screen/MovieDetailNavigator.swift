//
//  MovieDetailNavigator.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/30/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Foundation

protocol MovieDetailNavigatorType {
    func toMovieDetail(movie: Movie)
}

struct MovieDetailNavigator: MovieDetailNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toMovieDetail(movie: Movie) {
        let viewController = MovieDetailViewController.instantiate()
        let useCase = MovieDetailUseCase()
        let viewModel = MovieDetailViewModel(navigator: self, useCase: useCase, movie: movie)
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
