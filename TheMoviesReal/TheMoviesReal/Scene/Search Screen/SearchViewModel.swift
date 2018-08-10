//
//  SearchViewModel.swift
//  TheMoviesReal
//
//  Created by Hai on 7/29/18.
//  Copyright © 2018 Hai. All rits reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import RxGesture

struct SearchViewModel: ViewModelType {
    struct  Input {
        let queryTrigger: Driver<String>
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let selectMovieTrigger: Driver<IndexPath>
        let dismissKeyboardFromCollectionViewTrigger: Driver<GestureRecognizer>
    }

    struct Output {
        let movieList: Driver<[Movie]>
        let loading: Driver<Bool>
        let refreshing: Driver<Bool>
        let loadingMore: Driver<Bool>
        let fetchItem: Driver<Void>
        let error: Driver<Error>
        let selectedMovie: Driver<Void>
        let isEmptyData: Driver<Bool>
        let dismissKeyboardFromCollectionView: Driver<Void>
    }
    
    let navigator: SearchNavigatorType
    let useCase: SearchUseCaseType
    
    func transform(_ input: SearchViewModel.Input) -> SearchViewModel.Output {
        let loadMoreOutput = setupLoadMorePagingWithParam(
            loadTrigger: input.queryTrigger,
            getItems: { query -> Observable<PagingInfo<Movie>> in
                self.useCase.getMovieList(query: query)
        },
            refreshTrigger: input.reloadTrigger.withLatestFrom(input.queryTrigger),
            refreshItems: { query -> Observable<PagingInfo<Movie>> in
                self.useCase.getMovieList(query: query)
        },
            loadMoreTrigger: input.loadMoreTrigger.withLatestFrom(input.queryTrigger),
            loadMoreItems: { query, page -> Observable<PagingInfo<Movie>> in
                self.useCase.loadMoreMovieList(query: query, page: page)
        }
        )
        let (page, fetchItem, loadError, Loading, refreshing, loadingMore) = loadMoreOutput
        
        let movieList = page
            .map { PagingInfo in
                return PagingInfo.items
        }
        .asDriverOnErrorJustComplete()
        
        let selectedMovie = input.selectMovieTrigger
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
        
        let isEmptyData = Driver.combineLatest(movieList, Loading)
            .filter { element in
                !element.1
            }
            .map { element in
                element.0.isEmpty
            }
        
        let dismissKeybroadFromCollectionView = input.dismissKeyboardFromCollectionViewTrigger
            .mapToVoid()
        
        return Output(
            movieList: movieList,
            loading: Loading,
            refreshing: refreshing,
            loadingMore: loadingMore,
            fetchItem: fetchItem,
            error: loadError,
            selectedMovie: selectedMovie,
            isEmptyData: isEmptyData,
            dismissKeyboardFromCollectionView: dismissKeybroadFromCollectionView
        )
    }
}
