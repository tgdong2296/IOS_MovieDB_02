//
//  PersonNavigator.swift
//  TheMoviesReal
//
//  Created by Hai on 8/5/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import UIKit

protocol PersonNavigatorType {
    func toPerson(personId: Int)
    func toMovieDetail(movie: Movie)
}

struct PersonNavigator: PersonNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toPerson(personId: Int) {
        let viewController = PersonViewController.instantiate()
        let useCase = PersonUseCase()
        let viewModel = PersonViewModel(navigator: self, useCase: useCase, personId: personId)
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toMovieDetail(movie: Movie) {
        let navigator = MovieDetailNavigator(navigationController: navigationController)
        navigator.toMovieDetail(movie: movie)
    }
}
