//
//  GenreCell.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/24/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable

class GenreCell: UICollectionViewCell, Reusable {
    @IBOutlet private weak var genreNameLabel: UILabel!
    
    func configCell(genre: Genre) {
        genreNameLabel.text = genre.name
    }
}
