//
//  APIService.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/23/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import RxSwift

struct APIService {
    static let share = APIService()
    
    private var alamofireManager = Alamofire.SessionManager.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager.adapter = CustomRequestAdapter()
    }
    
    func request<T: Mappable>(input: BaseRequest) -> Observable<T> {
        print("\n------------REQUEST INPUT")
        print("link: %@", input.url)
        print("body: %@", input.body ?? "No Body")
        print("------------ END REQUEST INPUT\n")
        
        return Observable.create { observer in
            self.alamofireManager.request(input.url, method: input.requestType,
                                          parameters: input.body, encoding: input.encoding)
                .validate(statusCode: 200..<500)
                .responseJSON { response in
                    print(response.request?.url ?? "Error")
                    print(response)
                    switch response.result {
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else {
                            observer.on(.error(BaseError.unexpectedError))
                            return
                        }
                        if statusCode == 200 {
                            if let object = Mapper<T>().map(JSONObject: value) {
                                observer.onNext(object)
                            }
                        } else {
                            guard let object = Mapper<ErrorResponse>().map(JSONObject: value) else {
                                observer.onError(BaseError.httpError(httpCode: statusCode))
                                return
                            }
                            observer.onError(BaseError.apiFailure(error: object))
                        }
                    case .failure:
                        observer.onError(BaseError.networkError)
                    }
                    observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
