//
//  ReviewNavigator.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/6/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit

protocol ReviewNavigatorType {
    func toReviewDetail(movie: Movie)
}

struct ReviewNavigator: ReviewNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toReviewDetail(movie: Movie) {
        let viewController = ReviewViewController.instantiate()
        let useCase = ReviewUseCase()
        let viewModel = ReviewViewModel(useCase: useCase, navigator: self, movie: movie)
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
