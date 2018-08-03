//
//  SearchViewController.swift
//  TheMoviesReal
//
//  Created by Hai on 7/29/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import MBProgressHUD
import NSObject_Rx

final class SearchViewController: UIViewController, BindableType {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: LoadMoreCollectionView!
    @IBOutlet private weak var noResultLabel: UILabel!
    private var options = Options()
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        collectionView.register(cellType: MovieCollectionCell.self)
        collectionView.alwaysBounceVertical = true
        collectionView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
    }
    
    func bindViewModel() {
        let input = SearchViewModel.Input(
            queryTrigger: searchBar.rx.text.orEmpty.asDriver()
                .distinctUntilChanged()
                .filter { !$0.isEmpty }
                .throttle(2),
            loadTrigger: Driver.just(()),
            reloadTrigger: collectionView.refreshTrigger,
            loadMoreTrigger: collectionView.loadMoreTrigger,
            selectMovieTrigger: collectionView.rx.itemSelected.asDriver()
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
        output.loading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        output.loadingMore
            .drive(collectionView.loadingMore)
            .disposed(by: rx.disposeBag)
        output.refreshing
            .drive(collectionView.refreshing)
            .disposed(by: rx.disposeBag)
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        output.selectedMovie
            .drive()
            .disposed(by: rx.disposeBag)
        output.fetchItem
            .drive()
            .disposed(by: rx.disposeBag)
        output.isEmptyData
            .drive(onNext: { [unowned self] isEmpty in
                self.noResultLabel.isHidden = !isEmpty
            })
            .disposed(by: rx.disposeBag)

    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    fileprivate struct Options {
        var itemSpacing: CGFloat = 8
        var lineSpacing: CGFloat = 8
        var itemPerRow: Int = 3
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
            + CGFloat(options.itemPerRow - 1) * options.itemSpacing
        let availableWidth = screenSize.width - paddingSpace
        let cellWidth = availableWidth / CGFloat(options.itemPerRow)
        let cellHeight = screenSize.height / 3 - 2 * paddingSpace
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return options.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return options.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return options.itemSpacing
    }
}

// MARK: - Navigation
extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.search
}
