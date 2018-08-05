//
//  PersonViewController.swift
//  TheMoviesReal
//
//  Created by Hai on 8/5/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable
import RxCocoa
import RxSwift
import NSObject_Rx

class PersonViewController: UIViewController, BindableType {

    @IBOutlet private weak var imgPerson: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var departmentLabel: UILabel!
    @IBOutlet private weak var popularityLabel: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var biographyLabel: UILabel!
    @IBOutlet private weak var birthPlaceLabel: UILabel!
    @IBOutlet private weak var seeMoreButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var biographyHeightConstraint: NSLayoutConstraint!
    
    private var options = Options()
    var viewModel: PersonViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configview()
    }
    
    private func configview() {
        collectionView.register(cellType: PersonMovieCell.self)
        collectionView.alwaysBounceHorizontal = true
        collectionView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
    }
    
    func bindViewModel() {
        let input = PersonViewModel.Input(
            loadTrigger: Driver.just(()),
            seeMoreTrigger: seeMoreButton.rx.tap.asDriver(),
            toMovieDetailTrigger: collectionView.rx.itemSelected.asDriver()
            )
        
        let output = viewModel.transform(input)
        
        output.movieList
            .drive(collectionView.rx.items) { collectionView, index, element in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: PersonMovieCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configCell(imagePath: element.posterPath, name: element.title)
                return cell
        }
        .disposed(by: rx.disposeBag)
        
        output.toMovieDetail
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.biographyState
            .drive(onNext: { [unowned self] state in
                self.changeLabelHeight(state: state)
            })
            .disposed(by: rx.disposeBag)
        
        output.personName
            .drive(nameLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.personDepartment
            .drive(departmentLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.personImage
            .drive(imgPerson.rx.profilePath)
            .disposed(by: rx.disposeBag)
        
        output.personPopularity
            .drive(popularityLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.personBiography
            .drive(biographyLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.personBirthday
            .drive(birthdayLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        
        output.activityIndicator
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        
        output.personBirthPlace
            .drive(birthPlaceLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }

    private func changeLabelHeight(state: Bool) {
        if state {
            UIView.animate(withDuration: 4, animations: {
                let width = UIScreen.main.bounds.width - 16
                let height = self.biographyLabel?.text?.heightWithConstrainedWidth(width: width) ?? 0
                self.biographyHeightConstraint?.constant = height + 10
                self.seeMoreButton.setTitle("<< See Less", for: .normal)
            })
        } else {
            UIView.animate(withDuration: 4, animations: {
                self.biographyHeightConstraint?.constant = 40
                self.seeMoreButton.setTitle("See More >>", for: .normal)
            })
        }
    }
}

extension PersonViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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

extension PersonViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.person
}
