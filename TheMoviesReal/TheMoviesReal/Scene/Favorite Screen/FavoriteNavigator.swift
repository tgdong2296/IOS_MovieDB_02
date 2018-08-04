//
//  FavoriteNavigator.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/1/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol FavoriteNavigatorType {
    func toMovieDetail(movie: Movie)
    func confirmDelete(movie: Movie) -> Driver<Void>
}

struct FavoriteNavigator: FavoriteNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toMovieDetail(movie: Movie) {
        let navigator = MovieDetailNavigator(navigationController: navigationController)
        navigator.toMovieDetail(movie: movie)
    }
    
    func confirmDelete(movie: Movie) -> Driver<Void> {
        return Observable<Void>.create({ observer -> Disposable in
            let alert = UIAlertController(title: "Delete movie: " + movie.title,
                                          message: "Do you want to delete this movie from Favorite list?",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Delete",
                                         style: .destructive) { _ in
                                            observer.onNext(())
                                            observer.onCompleted()
            }
            alert.addAction(okAction)
            
            let canelAction = UIAlertAction(title: "Cancel",
                                            style: .cancel) { _ in
                                                observer.onCompleted()
            }
            alert.addAction(canelAction)
            
            self.navigationController.present(alert, animated: true, completion: nil)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        })
        .asDriverOnErrorJustComplete()
    }
}
