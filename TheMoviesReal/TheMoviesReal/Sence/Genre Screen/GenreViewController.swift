//
//  GenreViewController.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/24/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import RxCocoa
import RxSwift
import MBProgressHUD
import NSObject_Rx

class GenreViewController: UIViewController, BindableType {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var viewModel: GenreViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        let input = GenreViewModel.Input(
            loadTrigger: Driver.just(()),
            selectGenreTrigger: collectionView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input)
        output.genreList
            .drive(collectionView.rx.items) { collectionView, index, element in
                let indexPath = IndexPath(row: index, section: 0)
                let cell: GenreCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configCell(genre: element)
                return cell
            }
            .disposed(by: rx.disposeBag)
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        output.indicator
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
    }
}

extension GenreViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.genre
}
