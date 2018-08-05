//
//  PersonMovieCell.swift
//  TheMoviesReal
//
//  Created by Hai on 8/7/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import SDWebImage
import Reusable

class PersonMovieCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var imgPoster: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(imagePath: String, name: String) {
        let imageUrl = URL(string: URLs.APIMoviePosterPath + imagePath)
        imgPoster.sd_setImage(with: imageUrl, placeholderImage: nil)
        nameLabel.text = name
    }
}
