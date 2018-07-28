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
    
    var collectionViewOffset: CGFloat {
        set { cellCollectionView.contentOffset.x = newValue }
        get { return cellCollectionView.contentOffset.x }
    }
    
    @IBOutlet private weak var cellTitle: UILabel!
    @IBOutlet private weak var cellCollectionView: UICollectionView!
        
    
    func updateCell(category: String) {
        cellTitle.text = category
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
