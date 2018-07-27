//
//  HomeViewController.swift
//  TheMoviesReal
//
//  Created by Hai on 7/24/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import MBProgressHUD
import NSObject_Rx

final class HomeViewController: UIViewController, BindableType {
    fileprivate var storedOffsets = [Int: CGFloat]()
    fileprivate var allMovie = [[Movie]]()
    fileprivate var movieListFake = [Movie]()
    var viewModel: MainViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let logo = #imageLiteral(resourceName: "img_navigator_bar_title")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    private func setupTableView() {
        for _ in 0..<4 {
            let movieList = movieListFake
            allMovie.append(movieList)
        }
        tableView.register(cellType: TableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func bindViewModel() {
        let input = MainViewModel.Input(
            loadTrigger: Driver.just(())
        )
        
        let output = viewModel.transform(input)
        
        output.movieListPopular.drive(onNext: { [weak self] value in
            guard let `self` = self else { return }
            self.allMovie[0] = value
            self.tableView.reloadData()
            print(self.allMovie.count)
        }).disposed(by: rx.disposeBag)
        output.movieListNowPlaying.drive(onNext: { [weak self] value in
            guard let `self` = self else { return }
            self.allMovie[1] = value
            self.tableView.reloadData()
            print(self.allMovie.count)
        }).disposed(by: rx.disposeBag)
        output.movieListUpcoming.drive(onNext: { [weak self] value in
            guard let `self` = self else { return }
            self.allMovie[2] = value
            self.tableView.reloadData()
            print(self.allMovie.count)
        }).disposed(by: rx.disposeBag)
        output.movieListTopRated.drive(onNext: { [weak self] value in
            guard let `self` = self else { return }
            self.allMovie[3] = value
            self.tableView.reloadData()
            print(self.allMovie.count)
        }).disposed(by: rx.disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        output.indicator
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? TableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? TableViewCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constant.homeTableViewCellHeight)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.homeCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TableViewCell.self)
        cell.updateCell(category: Constant.homeCategories[indexPath.row])
        return cell
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let row = collectionView.tag
        let movieList = allMovie[row]
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeCollectionViewCell.self)
        let row = collectionView.tag
        let movieList = allMovie[row]
        let movie = movieList[indexPath.row]
        cell.setContentForCollectionViewCell(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.homeCollectionViewCellWidth, height: Constant.homeCollectionViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(Constant.homeMinimumLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - StoryboardSceneBased
extension HomeViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
