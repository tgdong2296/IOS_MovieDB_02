//
//  UIViewController+.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/24/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertError(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Error",message: message,preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
