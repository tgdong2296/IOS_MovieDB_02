//
//  FavoriteViewController.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/1/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import Foundation
import Reusable

class FavoriteViewController: UIViewController, BindableType {
    private struct Constants {
        static let screenTitle = "Favorite Movie"
        static let deleteAction = "Delete"
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyMovieLabel: UILabel!
    
    private let loadDataTrigger = PublishSubject<Void>()
    private let deleteTrigger = PublishSubject<IndexPath>()
    var viewModel: FavoriteViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configview()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func setupData() {
        let navigator = FavoriteNavigator(navigationController: navigationController!)
        viewModel = FavoriteViewModel(navigator: navigator, useCase: FavoriteUseCase())
        bindViewModel()
    }
    
    private func configview() {
        tableView.register(cellType: FavoriteCell.self)
        tableView.alwaysBounceVertical = true
        tableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        self.navigationItem.title = Constants.screenTitle
    }
    
    private func loadData() {
        loadDataTrigger.onNext(())
    }
    
    func bindViewModel() {
        let input = FavoriteViewModel.Input(
            loadTrigger: loadDataTrigger.asDriverOnErrorJustComplete(),
            selectItemTrigger: tableView.rx.itemSelected.asDriver(),
            deleteTrigger: deleteTrigger.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input)
        
        output.favoriteList
            .drive(tableView.rx.items) { tableView, index, element in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: FavoriteCell = tableView.dequeueReusableCell(for: indexPath)
                cell.configCell(movie: element)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.isEmpty
            .drive(onNext: { [unowned self] isEmpty in
                self.emptyMovieLabel.isHidden = !isEmpty
            })
            .disposed(by: rx.disposeBag)
        
        output.deletedMovie
            .drive(onNext: { [unowned self] _ in
                self.loadData()
            })
            .disposed(by: rx.disposeBag)
        
        output.selectedMovie
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        
        output.indicator
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal,title: Constants.deleteAction) {
            [weak self] (action, indexPath) in
            guard let `self` = self else {
                return
            }
            self.deleteTrigger.onNext(indexPath)
        }
        deleteAction.backgroundColor = UIColor.orange
        return [deleteAction]
    }
}

extension FavoriteViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
