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
import iCarousel
import Then

final class HomeViewController: UIViewController, BindableType {
    private struct Constants {
        static let bannerWidth = UIScreen.main.bounds.width - 60
        static let bannerHeight = (UIScreen.main.bounds.width - 60) / 2
        static let labelWidth = UIScreen.main.bounds.width - 60
        static let labelHeight = (UIScreen.main.bounds.width - 60) / 8
    }
    
    fileprivate var storedOffsets = [Int: CGFloat]()
    fileprivate var allMovie = [[Movie]]()
    fileprivate var movieListFake = [Movie]()
    private let toMovieListSubject = PublishSubject<MovieListType>()
    private let toMovieDetailSubject = PublishSubject<Movie>()
    private let bannerSelectTrigger = PublishSubject<Int>()
    fileprivate var carouseViewOffset: CGFloat = 0
    fileprivate var banners = [Movie]()
    fileprivate var timer: Timer?
    var viewModel: MainViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var toSearchButton: UIBarButtonItem!
    @IBOutlet private weak var carouselView: iCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        configview()
    }
    
    private func configview() {
        carouselView.type = .rotary
        carouselView.isPagingEnabled = true
        startTimer()
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
            loadTrigger: Driver.just(()),
            toMovieTypeTrigger: toMovieListSubject.asDriverOnErrorJustComplete(),
            toSearchTrigger: toSearchButton.rx.tap.asDriver(),
            toMovieDetailTrigger: toMovieDetailSubject.asDriverOnErrorJustComplete(),
            bannerSelectTrigger: bannerSelectTrigger.asDriverOnErrorJustComplete()
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
        
        output.bannerList
            .drive(onNext: { [weak self] banners in
                guard let `self` = self else { return }
                self.banners = banners
                self.carouselView.reloadData()
            })
            .disposed(by: rx.disposeBag)
        
        output.bannerSelected
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        output.indicator
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        output.toSearch
            .drive()
            .disposed(by: rx.disposeBag)
        output.toMovieType
            .drive()
            .disposed(by: rx.disposeBag)
        output.toMovieDetail
            .drive()
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - iCarouse Library
extension HomeViewController: iCarouselDataSource, iCarouselDelegate {
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self,
                                     selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    private func pauseTimer() {
        timer?.invalidate()
    }
    
    @objc private func autoScroll() {
        UIView.animate(withDuration: 1, animations: {
            self.carouseViewOffset = self.carouseViewOffset == CGFloat(self.banners.count - 1)
                ? 0 : self.carouseViewOffset + 1
            self.carouselView.scrollOffset = self.carouseViewOffset
        })
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return banners.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let itemView = UIImageView().then {
            $0.frame = CGRect(x: 0, y: 0, width: Constants.bannerWidth, height: Constants.bannerHeight)
            $0.contentMode = .center
        }
        
        let imageContentView = UIImageView().then {
            $0.frame = itemView.bounds
            $0.backgroundColor = .clear
            $0.dropShadow(width: Constants.bannerWidth, height: Constants.bannerHeight)
        }
        
        let blackView = UIView().then {
            $0.frame = CGRect(x: 0, y: itemView.bounds.height - Constants.labelHeight,
                              width: Constants.labelWidth, height: Constants.labelHeight)
            $0.backgroundColor = .black
            $0.alpha = 0.8
        }
        
        let nameLabel = UILabel().then {
            $0.frame = CGRect(x: 10, y: itemView.bounds.height - Constants.labelHeight,
                              width: Constants.labelWidth, height: Constants.labelHeight)
            $0.textColor = .white
        }
        
        itemView.addSubview(imageContentView)
        itemView.addSubview(blackView)
        itemView.addSubview(nameLabel)
        
        let imageUrl = URL(string: URLs.APIMovieBackdropPath + banners[index].backdropPath)
        imageContentView.sd_setImage(with: imageUrl, placeholderImage: nil)
        nameLabel.text = banners[index].title
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func carouselWillBeginDragging(_ carousel: iCarousel) {
        pauseTimer()
    }
    
    func carouselDidEndDragging(_ carousel: iCarousel, willDecelerate decelerate: Bool) {
        carouseViewOffset = CGFloat(carouselView.currentItemIndex)
        startTimer()
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        bannerSelectTrigger.onNext(index)
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
       let listType = Constant.homeCategories[indexPath.row]
        cell.updateCell(category: listType)
        cell.toMovieListAction = { [weak self] in
            guard let `self` = self else { return }
            self.toMovieListSubject.onNext(listType)
        }
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
        let row = collectionView.tag
        let movieList = allMovie[row]
        let movie = movieList[indexPath.row]
        self.toMovieDetailSubject.onNext(movie)
    }
}

// MARK: - StoryboardSceneBased
extension HomeViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
