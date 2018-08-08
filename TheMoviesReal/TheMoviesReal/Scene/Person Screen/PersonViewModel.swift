//
//  PersonViewModel.swift
//  TheMoviesReal
//
//  Created by Hai on 8/5/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct PersonViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let seeMoreTrigger: Driver<Void>
        let toMovieDetailTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let error: Driver<Error>
        let activityIndicator: Driver<Bool>
        let personName: Driver<String>
        let personImage: Driver<String>
        let personBirthday: Driver<String>
        let personPopularity: Driver<String>
        let personBiography: Driver<String>
        let personDepartment: Driver<String>
        let personBirthPlace: Driver<String>
        let biographyState: Driver<Bool>
        let movieList: Driver<[Movie]>
        let toMovieDetail: Driver<Void>
    }
    
    let navigator: PersonNavigatorType
    let useCase: PersonUseCaseType
    let personId: Int
    
    func transform(_ input: PersonViewModel.Input) -> PersonViewModel.Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        let stateSeeMore = BehaviorRelay(value: false)
        
        let person = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getPerson(personId: self.personId)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
        }
        
        let personName = person
            .map { person in
                return person.name
        }
        
        let personImage = person
            .map { person in
                return person.prolifePath
        }
        
        let personBirthday = person
            .map { person -> String in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM-dd-yyyy"
                let dateString = dateFormatter.string(from: person.birthday)
                return dateString
        }
        
        let personPopularity = person
            .map { person in
                return "\(Int(person.popularity * 1000))"
        }
        
        let personBiography = person
            .map { person in
                return person.biography
        }
        
        let personDepartment = person
            .map { person in
                return person.job
        }
        
        let personBirthPlace = person
            .map { person in
                return person.birthPlace
        }
        
        let biographyState = input.seeMoreTrigger
            .withLatestFrom(stateSeeMore.asDriver())
            .map { state -> Bool in
                stateSeeMore.accept(!state)
                return !state
        }
        
        let movieList = input.loadTrigger
            .flatMapLatest { _ in
                return self.useCase.getPersonCredit(personId: self.personId)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
        }
        
        let toMovieDetail = input.toMovieDetailTrigger
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
        
        return Output(
            error: errorTracker.asDriver(),
            activityIndicator: activityIndicator.asDriver(),
            personName: personName,
            personImage: personImage,
            personBirthday: personBirthday,
            personPopularity: personPopularity,
            personBiography: personBiography,
            personDepartment: personDepartment,
            personBirthPlace: personBirthPlace,
            biographyState: biographyState,
            movieList: movieList,
            toMovieDetail: toMovieDetail
        )
    }
}
