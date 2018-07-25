//
//  GenreNavigator.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/24/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import UIKit

protocol GenreNavigatorType {
    func toGenreScreen()
    func toGenreDetailScreen(genreId: Int)
}

struct GenreNavigator: GenreNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toGenreScreen() {
        let genreViewController = GenreViewController.instantiate()
        let genreViewModel = GenreViewModel(navigator: self, useCase: GenreUseCase())
        genreViewController.bindViewModel(to: genreViewModel)
        navigationController.pushViewController(genreViewController, animated: true)
    }
    
    func toGenreDetailScreen(genreId: Int) {
    }
}
