//
//  MovieCollectionViewController.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/26/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class GenreDetailViewController: UIViewController, BindableType {
    @IBOutlet private weak var collectionView: LoadMoreCollectionView!
    
    private var options = Options()
    var viewModel: GenreDetailViewModel!
    var genre: Genre?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cofigView()
    }
    
    private func cofigView() {
        collectionView.register(cellType: MovieCollectionCell.self)
        collectionView.alwaysBounceVertical = true
        collectionView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        if let genre = genre {
            self.title = "\(genre.name) Movies"
        }
    }
    
    func bindViewModel() {
        let input = GenreDetailViewModel.Input(
            loadTrigger: Driver.just(()),
            reloadTrigger: collectionView.refreshTrigger,
            loadMoreTrigger: collectionView.loadMoreTrigger,
            selectedMovieTrigger: collectionView.rx.itemSelected.asDriver()
        )
        let output = viewModel.transform(input)
        output.movieList
            .drive(collectionView.rx.items) { collectionView, index, element in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: MovieCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configCell(movie: element)
                return cell
            }
            .disposed(by: rx.disposeBag)
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        output.loading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        output.refreshing
            .drive(collectionView.refreshing)
            .disposed(by: rx.disposeBag)
        output.loadingMore
            .drive(collectionView.loadingMore)
            .disposed(by: rx.disposeBag)
        output.fetchItem
            .drive()
            .disposed(by: rx.disposeBag)
        output.selectedMovie
            .drive()
            .disposed(by: rx.disposeBag)
        output.isEmptyDara
            .drive()
            .disposed(by: rx.disposeBag)
    }
}

extension GenreDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    fileprivate struct Options {
        var itemSpacing: CGFloat = 8
        var lineSpacing: CGFloat = 8
        var itemsPerRow: Int = 3
        var sectionInsets: UIEdgeInsets = UIEdgeInsets(
            top: 10.0,
            left: 10.0,
            bottom: 10.0,
            right: 10.0
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let paddingSpace = options.sectionInsets.left
            + options.sectionInsets.right
            + CGFloat(options.itemsPerRow - 1) * options.itemSpacing
        let availableWidth = screenSize.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(options.itemsPerRow)
        let heightPerItem = screenSize.height / 3 - 2 * paddingSpace
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return options.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return options.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return options.itemSpacing
    }
}

extension GenreDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.genre
}
