//
//  GenreDetailViewModel.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/27/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct GenreDetailViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let selectedMovieTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let error: Driver<Error>
        let loading: Driver<Bool>
        let refreshing: Driver<Bool>
        let loadingMore: Driver<Bool>
        let fetchItem: Driver<Void>
        let movieList: Driver<[Movie]>
        let selectedMovie: Driver<Void>
        let isEmptyDara: Driver<Bool>
    }
    
    let navigator: GenreDetailNavigator
    let useCase: GenreDetailUseCase
    let genre: Genre
    
    func transform(_ input: GenreDetailViewModel.Input) -> GenreDetailViewModel.Output {
        let loadMoreOutput = setupLoadMorePaging(
            loadTrigger: input.loadTrigger,
            getItems: useCase.getMovieList,
            refreshTrigger: input.reloadTrigger,
            refreshItems: useCase.getMovieList,
            loadMoreTrigger: input.loadMoreTrigger,
            loadMoreItems: useCase.loadMoreMovieList
        )
        let (page,  fetchItems, loadError, loading, refreshing, loadingMore) = loadMoreOutput
        
        let movieList = page
            .map { element in
                return element.items
            }
            .asDriverOnErrorJustComplete()
        let selectedMovie = input.selectedMovieTrigger
            .withLatestFrom(movieList) { indexPath, movieList in
                return (indexPath, movieList)
            }
            .map { (indexPath, movieList) in
                return movieList[indexPath.row]
            }
            .do(onNext: { movie in
                self.navigator.toMovieDetail(movie: movie)
            })
            .mapToVoid()
        let isEmptyData = Driver.combineLatest(movieList, loading)
            .filter { element in
                !element.1
            }
            .map { element in
                element.0.isEmpty
            }
        return Output(
            error: loadError,
            loading: loading,
            refreshing: refreshing,
            loadingMore: loadingMore,
            fetchItem: fetchItems,
            movieList: movieList,
            selectedMovie: selectedMovie,
            isEmptyDara: isEmptyData
        )
    }
}
