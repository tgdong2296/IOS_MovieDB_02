//
//  HomeCollectionViewCell.swift
//  TheMoviesReal
//
//  Created by Hai on 7/24/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

final class HomeCollectionViewCell: UICollectionViewCell, NibReusable {
    @IBOutlet private weak var moviePoster: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!

    func setContentForCollectionViewCell(movie: Movie) {
        self.movieTitle.text = movie.title
        let posterPath = movie.posterPath
        let url = URL(string: URLs.APIMoviePosterPath + posterPath)
        self.moviePoster.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img_poster_placeholder"))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
