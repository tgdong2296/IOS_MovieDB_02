//
//  PersonUseCase.swift
//  TheMoviesReal
//
//  Created by Hai on 8/5/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol PersonUseCaseType {
    func getPerson(personId: Int) -> Observable<Person>
    func getPersonCredit(personId id: Int) -> Observable<[Movie]>
}

struct PersonUseCase: PersonUseCaseType {
    func getPerson(personId: Int) -> Observable<Person> {
        let request = PersonRequest(personId: personId)
        let repository = PersonRepositoryImp(api: APIService.share)
        return repository.getPerson(input: request)
    }
    
    func getPersonCredit(personId id: Int) -> Observable<[Movie]> {
        let request = PersonCreditRequest(personId: id)
        let repository = CreditRepositoryImp(api: APIService.share)
        return repository.getPersonCredit(input: request)
            .map { creditRespone in
                let movies = creditRespone.casts + creditRespone.crews
                return Array(movies.prefix(10))
        }
    }
}
