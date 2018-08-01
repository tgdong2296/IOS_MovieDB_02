//
//  GenreDetailNavigator.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/27/18.
//  Copyright © 2018 Hai. All rights reserved.
//
import UIKit

protocol GenreDetailNavigatorType {
    func toGenreDetail(genre: Genre)
    func toMovieDetail(movie: Movie)
}

struct GenreDetailNavigator: GenreDetailNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toGenreDetail(genre: Genre) {
        let genreDetailViewController = GenreDetailViewController.instantiate()
        genreDetailViewController.genre = genre
        let genreDetailUseCase = GenreDetailUseCase(genre: genre)
        let genreDetailViewModel = GenreDetailViewModel(navigator: self, useCase: genreDetailUseCase, genre: genre)
        genreDetailViewController.bindViewModel(to: genreDetailViewModel)
        navigationController.pushViewController(genreDetailViewController, animated: true)
    }
    
    func toMovieDetail(movie: Movie) {
        let navigator = MovieDetailNavigator(navigationController: navigationController)
        navigator.toMovieDetail(movie: movie)
    }
}
