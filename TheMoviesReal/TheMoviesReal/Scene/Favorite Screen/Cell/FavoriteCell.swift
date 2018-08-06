//
//  FavoriteCell.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/2/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import Cosmos

class FavoriteCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var imgPoster: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var starRating: CosmosView!
    @IBOutlet private weak var viewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configview()
    }
    
    private func configview() {
        self.selectionStyle = .none
        let width = UIScreen.main.bounds.width - 16
        viewContainer.dropShadow(width: width, height: viewContainer.bounds.height)
    }
    
    func configCell(movie: Movie) {
        let imageUrl = URL(string: URLs.APIMoviePosterPath + movie.posterPath)
        imgPoster.sd_setImage(with: imageUrl, placeholderImage: nil)
        nameLabel.text = movie.title
        dateLabel.text = "\(movie.popularity)"
        starRating.rating = Double(movie.voteAverage / 2)
        starRating.text = "(\(movie.voteAverage))"
    }
}
