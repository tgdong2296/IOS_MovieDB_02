//
//  BannerRepository.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/4/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import RxSwift
import hpple

protocol BannerRepository {
    func getBanners() -> Observable<[Movie]>
}

class BannerRepositoryImp: BannerRepository {
    required init() {
    }
    
    func getBanners() -> Observable<[Movie]> {
        return Observable.create { observer in
            var banners = [Movie]()
            let url = URL(string: URLs.HomePageURL)
            guard let webUrl = url else {
                observer.onError(BaseError.unexpectedError)
                return Disposables.create()
            }
            var myHTMLString: String?
            do {
                myHTMLString = try String(contentsOf: webUrl , encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            } catch let error {
                observer.onError(error)
            }
            let doc = TFHpple(htmlData: myHTMLString?.data(using: .utf8))
            
            guard let imageElements = doc?.search(withXPathQuery: "//div[@class='column']/div/a/img") as? [TFHppleElement],
                let idElements = doc?.search(withXPathQuery: "//div[@class='column']/div/a") as? [TFHppleElement]
                else {
                        observer.onError(BaseError.unexpectedError)
                        return Disposables.create()
            }
            for index in 0 ..< imageElements.count {
                let imageElementValue = Array(imageElements[index].attributes.values)
                let bannerName = imageElementValue[2] as? String ?? ""
                let imageUrlString = imageElements[index].attributes.first?.value ?? ""
                let bannerUrl: String = (imageUrlString as AnyObject).components(separatedBy: " ")[2]
                let idUrlString = idElements[index].attributes.first?.value ?? ""
                let bannerId = Int((idUrlString as AnyObject).components(separatedBy: "/")[2]) ?? 0
                
                let banner = Movie(id: bannerId, title: bannerName, backdropPath: bannerUrl)
                banners.append(banner)
            }
            
            observer.onNext(banners)
            observer.onCompleted()
            return Disposables.create()
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
