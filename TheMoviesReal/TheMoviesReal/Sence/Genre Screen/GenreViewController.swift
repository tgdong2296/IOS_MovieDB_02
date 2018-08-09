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
import Then

class GenreViewController: UIViewController, BindableType {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var options = Options()
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
        collectionView.do {
            $0.register(cellType: GenreCell.self)
            $0.alwaysBounceVertical = true
        }
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

extension GenreViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    fileprivate struct Options {
        var itemSpacing: CGFloat = 8
        var lineSpacing: CGFloat = 8
        var itemsPerRow: Int = 2
        var height: CGFloat = 50
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
        let heightPerItem = options.height
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension GenreViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
