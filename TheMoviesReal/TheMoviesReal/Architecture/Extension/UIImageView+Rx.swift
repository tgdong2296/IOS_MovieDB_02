//
//  UIImageView+Rx.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/31/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import SDWebImage

extension Reactive where Base: UIImageView {
    var posterPath: Binder<String> {
        return Binder(base) { view, posterPath in
            let imageUrl = URL(string: URLs.APIMoviePosterPath + posterPath)
            view.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "img_poster_placeholder"))
        }
    }
    
    var profilePath: Binder<String> {
        return Binder(base) { view, profilePath in
            let imageUrl = URL(string: URLs.APIPersonProfilePath + profilePath)
            view.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "img_profile_placeholder"))
        }
    }
}
