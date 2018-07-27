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
}

struct MainNavigator: MainNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toGenres() {
        let navigator = GenreNavigator(navigationController: navigationController)
        navigator.toGenreScreen()
    }
}
