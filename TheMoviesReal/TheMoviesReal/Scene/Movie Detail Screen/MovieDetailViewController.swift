//
//  MovieDetailViewController.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/30/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Cosmos
import Reusable
import RxSwift
import RxCocoa
import NSObject_Rx
import youtube_ios_player_helper

class MovieDetailViewController: UIViewController, BindableType {
    private struct Constants {
        static let overviewEmpty = "This movie doesn't have overview!"
        static let addSuccess = "Added to Favorite!"
        static let deleteSuccess = "Deleted from Favorite!"
        static let reviewViewContainerHeightConstraint: CGFloat = 109
    }
    @IBOutlet private weak var imgPoster: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var startRatingView: CosmosView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var btnSeeMore: UIButton!
    @IBOutlet private weak var youtubeView: YTPlayerView!
    @IBOutlet private weak var actorCollectionView: UICollectionView!
    @IBOutlet private weak var creditCollectionView: UICollectionView!
    @IBOutlet private weak var overviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var reviewRateLabel: UILabel!
    @IBOutlet private weak var reviewStarRating: CosmosView!
    @IBOutlet private weak var reviewVoteCountLabel: UILabel!
    @IBOutlet private weak var reviewAuthorLabel: UILabel!
    @IBOutlet private weak var reviewDetailLabel: UILabel!
    @IBOutlet private weak var reviewButton: UIButton!
    @IBOutlet private weak var reviewViewContainer: UIView!
    @IBOutlet private weak var reviewViewContainerHeightConstraint: NSLayoutConstraint!
    
    private var options = Options()
    var viewModel: MovieDetailViewModel!
    let favoriteButton = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configview()
    }
    
    private func configview() {
        actorCollectionView.register(cellType: PersonCell.self)
        creditCollectionView.register(cellType: PersonCell.self)
        actorCollectionView.alwaysBounceHorizontal = true
        creditCollectionView.alwaysBounceHorizontal = true
        actorCollectionView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        creditCollectionView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        imgPoster.dropShadow(width: imgPoster.frame.width, height: imgPoster.frame.height)
        youtubeView.isHidden = true
        youtubeView.dropShadow(width: youtubeView.frame.width, height: youtubeView.frame.height)
        
        self.navigationController?.navigationItem.backBarButtonItem?.title = "Back"
        reviewViewContainerHeightConstraint.constant = 0
        reviewViewContainer.isHidden = true
    }
    
    func bindViewModel() {
        let input = MovieDetailViewModel.Input(
            loadTrigger: Driver.just(()),
            seeMoreTrigger: btnSeeMore.rx.tap.asDriver(),
            favoriteTrigger: favoriteButton.rx.tap.asDriver(),
            reviewDetailTrigger: reviewButton.rx.tap.asDriver(),
            toCastTrigger: actorCollectionView.rx.itemSelected.asDriver(),
            toCrewTrigger: creditCollectionView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input)
        output.castList
            .drive(actorCollectionView.rx.items) { collectionView, index, element in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: PersonCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configCell(imagePath: element.profilePath, name: element.name)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.crewList
            .drive(creditCollectionView.rx.items) { collectionView, index, element in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: PersonCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configCell(imagePath: element.profilePath, name: element.name)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.overviewState
            .drive(onNext: { [unowned self] state in
                self.changeLabelHeight(state: state)
            })
            .disposed(by: rx.disposeBag)
        
        output.favoriteState
            .drive(onNext: { [unowned self] state in
                self.changeRightBarButtonImage(image: state ? #imageLiteral(resourceName: "ic_like_100px") : #imageLiteral(resourceName: "ic_dislike_100px"))
            })
            .disposed(by: rx.disposeBag)
        
        output.favoriteAction
            .drive(onNext: { [unowned self] result in
                switch result {
                case .insertSuccess:
                    self.changeRightBarButtonImage(image: #imageLiteral(resourceName: "ic_like_100px"))
                    self.showToast(message: Constants.addSuccess)
                case .deleteSucess:
                    self.changeRightBarButtonImage(image: #imageLiteral(resourceName: "ic_dislike_100px"))
                    self.showToast(message: Constants.deleteSuccess)
                }
            })
            .disposed(by: rx.disposeBag)
        
        output.youtubeViewOutput
            .drive(youtubeView.rx.videoID)
            .disposed(by: rx.disposeBag)
        
        output.movieName
            .drive(nameLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.movieDuration
            .drive(durationLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.movieStatus
            .drive(statusLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.genreDetail
            .drive(genreLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.moviePoster
            .drive(imgPoster.rx.posterPath)
            .disposed(by: rx.disposeBag)
        
        output.movieRate
            .drive(startRatingView.rx.rate)
            .disposed(by: rx.disposeBag)
        
        output.firstReviewContent
            .drive(onNext: { [unowned self] content in
                self.reviewDetailLabel.text = content
                self.reviewViewContainer.isHidden = false
                self.reviewViewContainerHeightConstraint.constant = Constants.reviewViewContainerHeightConstraint
            })
            .disposed(by: rx.disposeBag)
        
        output.movieRate
            .drive(onNext: { [unowned self] rate in
                self.reviewStarRating.rating = Double(rate)
            })
            .disposed(by: rx.disposeBag)
        
        output.reviewRate
            .drive(reviewRateLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.voteCount
            .drive(reviewVoteCountLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.firstReviewAuthor
            .drive(reviewAuthorLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.reviewDetailClicked
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.movieName
            .drive(rx.screenTitle)
            .disposed(by: rx.disposeBag)
        
        output.movieOverview
            .drive(onNext: { [unowned self] overview in
                self.overviewLabel.text = overview.isEmpty ? Constants.overviewEmpty : overview
                self.btnSeeMore.isHidden = overview.isEmpty
            })
            .disposed(by: rx.disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        
        output.activityIndicator
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        
        output.toCast
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.toCrew
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    private func changeLabelHeight(state: Bool) {
        if state {
            UIView.animate(withDuration: 4, animations: {
                let width = UIScreen.main.bounds.width - 16
                let height = self.overviewLabel?.text?.heightWithConstrainedWidth(width: width) ?? 0
                self.overviewHeightConstraint?.constant = height + 10
                self.btnSeeMore.setTitle("<< See Less", for: .normal)
            })
        } else {
            UIView.animate(withDuration: 4, animations: {
                self.overviewHeightConstraint?.constant = 40
                self.btnSeeMore.setTitle("See More >>", for: .normal)
            })
        }
    }
    
    private func changeRightBarButtonImage(image: UIImage) {
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem.init(customView: favoriteButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        let widthPerItem = availableWidth / CGFloat(options.itemsPerRow) - paddingSpace
        let heightPerItem = widthPerItem * 1.5
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

extension MovieDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.movieDetail
}
