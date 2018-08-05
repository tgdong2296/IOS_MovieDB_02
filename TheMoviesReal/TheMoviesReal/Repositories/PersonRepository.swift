//
//  PersonRepository.swift
//  TheMoviesReal
//
//  Created by Hai on 8/5/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

protocol PersonRepository {
    func getPerson(input: PersonRequest) -> Observable<Person>
}

class PersonRepositoryImp: PersonRepository {
    private var api: APIService
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getPerson(input: PersonRequest) -> Observable<Person> {
        return api.request(input: input).map { (response: Person) -> Person in
            return response
        }
    }
}
