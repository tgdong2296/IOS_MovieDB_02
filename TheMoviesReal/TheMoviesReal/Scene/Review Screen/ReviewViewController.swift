//
//  ReviewViewController.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/6/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import Reusable
import Then
import Cosmos

class ReviewViewController: UIViewController, BindableType {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var reviewRate: UILabel!
    @IBOutlet private weak var reviewStarRating: CosmosView!
    @IBOutlet private weak var reviewVoteCount: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    
    var viewModel: ReviewViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configview()
    }
    
    private func configview() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        tableView.register(cellType: ReviewCell.self)
        posterImageView.dropShadow(width: posterImageView.frame.width, height: posterImageView.frame.height)
    }
    
    func bindViewModel() {
        let input = ReviewViewModel.Input(loadTrigger: Driver.just(()))
        let output = viewModel.transform(input)
        
        output.reviewList
            .drive(tableView.rx.items) { tableView, index, element in
                let indexPath = IndexPath(row: index, section: 0)
                let cell: ReviewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.configCell(review: element)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.reviewRate
            .drive(onNext: { [unowned self] rate in
                self.reviewStarRating.rating = Double(rate)
                self.reviewRate.text = "\(rate / 2)"
            })
            .disposed(by: rx.disposeBag)
        
        output.reviewVoteCount
            .drive(reviewVoteCount.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.posterUrl
            .drive(posterImageView.rx.posterPath)
            .disposed(by: rx.disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        
        output.indicator
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
    }
}

extension ReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ReviewViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.movieDetail
}
