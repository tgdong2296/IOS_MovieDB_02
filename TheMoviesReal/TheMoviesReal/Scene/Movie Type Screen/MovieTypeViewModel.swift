//
//  MovieTypeViewModel.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/28/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct MovieTypeViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTriger: Driver<Void>
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
        let isEmptyData: Driver<Bool>
    }
    
    let navigator: MovieTypeNavigatorType
    let useCase: MovieTypeUseCaseType
    var listType: MovieListType
    
    func transform(_ input: MovieTypeViewModel.Input) -> MovieTypeViewModel.Output {
        let loadMoreOutput = setupLoadMorePaging(
            loadTrigger: input.loadTrigger,
            getItems: { () -> Observable<PagingInfo<Movie>> in
                self.useCase.getMovieList(listType: self.listType)
            },
            refreshTrigger: input.reloadTrigger,
            refreshItems: { () -> Observable<PagingInfo<Movie>> in
                self.useCase.getMovieList(listType: self.listType)
            },
            loadMoreTrigger: input.loadMoreTriger,
            loadMoreItems: { page -> Observable<PagingInfo<Movie>> in
                self.useCase.loadMoreMovieList(listType: self.listType, page: page)
            }
        )
        let (page, fetchItem, loadError, loading, refreshing, loadingMore) = loadMoreOutput
        
        let movieList = page
            .map { pagingInfo in
                return pagingInfo.items
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
            fetchItem: fetchItem,
            movieList: movieList,
            selectedMovie: selectedMovie,
            isEmptyData: isEmptyData
        )
    }
}
