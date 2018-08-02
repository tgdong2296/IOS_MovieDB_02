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
}

struct MovieTypeNavigator: MovieTypeNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toMovieTypeScreen(listType: MovieListType) {
        let viewController = MovieTypeViewForMainController.instantiate()
        let useCase = MovieTypeUseCase()
        let viewModel = MovieTypeViewModel(navigator: self, useCase: useCase, listType: listType)
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
