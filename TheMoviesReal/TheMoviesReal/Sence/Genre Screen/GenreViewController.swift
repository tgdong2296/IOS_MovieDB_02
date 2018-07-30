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
        configView()
        setupData()
    }
    
    private func setupData() {
        let navigator = GenreNavigator(navigationController: navigationController!)
        viewModel = GenreViewModel(navigator: navigator, useCase: GenreUseCase())
        bindViewModel()
    }
    
    private func configView() {
        collectionView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
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
        output.selectedGenre
            .drive()
            .disposed(by: rx.disposeBag)
    }
}

extension GenreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension GenreViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
