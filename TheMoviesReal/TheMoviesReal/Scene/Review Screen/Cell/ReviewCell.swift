//
//  ReviewCell.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/6/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable

class ReviewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(review: Review) {
        authorLabel.text = review.author
        contentLabel.text = review.content
    }
}
