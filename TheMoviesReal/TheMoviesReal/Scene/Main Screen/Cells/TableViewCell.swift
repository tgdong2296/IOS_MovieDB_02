//
//  TableViewCell.swift
//  TheMoviesReal
//
//  Created by Hai on 7/24/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable

final class TableViewCell: UITableViewCell, NibReusable {
    static let reuseID = "TableViewCell"
    
    var toMovieListAction: (() -> Void)?
    var collectionViewOffset: CGFloat {
        set { cellCollectionView.contentOffset.x = newValue }
        get { return cellCollectionView.contentOffset.x }
    }
    
    @IBOutlet private weak var cellTitle: UILabel!
    @IBOutlet private weak var cellCollectionView: UICollectionView!
    @IBOutlet private weak var toMovieListTypeButton: UIButton!
    
    @IBAction func toMovieListButtonAction(_ sender: Any) {
        toMovieListAction?() 
    }
    
    func updateCell(category: MovieListType) {
        cellTitle.text = category.rawValue
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellCollectionView.register(cellType: HomeCollectionViewCell.self)
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        cellCollectionView.delegate = dataSourceDelegate
        cellCollectionView.dataSource = dataSourceDelegate
        cellCollectionView.tag = row
        cellCollectionView.setContentOffset(cellCollectionView.contentOffset, animated:false)
        cellCollectionView.reloadData()
    }
}
