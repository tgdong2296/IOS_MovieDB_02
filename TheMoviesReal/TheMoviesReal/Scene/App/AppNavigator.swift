//
//  AppNavigator.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/24/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import UIKit

protocol AppNavigatorType {
    func toMain()
}

struct AppNavigator: AppNavigatorType {
    unowned let window: UIWindow
    
    func toMain() {
        let vc = HomeViewController.instantiate()
        let nav = UINavigationController(rootViewController: vc)
        let navigator = MainNavigator(navigationController: nav)
        let useCase = MainUseCase()
        let vm = MainViewModel(navigator: navigator, useCase: useCase)
        vc.bindViewModel(to: vm)
        window.rootViewController = nav
    }
}
