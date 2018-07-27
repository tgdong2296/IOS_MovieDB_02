//
//  MovieCollectionCell.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/26/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
import Reusable

class MovieCollectionCell: UICollectionViewCell, NibReusable {
    @IBOutlet private weak var imgPoster: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var starRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(movie: Movie) {
        let imageUrl = URL(string: URLs.APIMoviePosterPath + movie.posterPath)
        imgPoster.sd_setImage(with: imageUrl, placeholderImage: nil)
        movieNameLabel.text = movie.title
        starRating.rating = Double(movie.voteAverage / 2)
    }
}
