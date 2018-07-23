//
//  CustomRequestAdapter.swift
//  TheMovies
//
//  Created by Trịnh Giang Đông on 7/23/18.
//  Copyright © 2018 TrinhGiangDong. All rights reserved.
//

import Foundation
import Alamofire

final class CustomRequestAdapter: RequestAdapter {
    private let userDefault = UserDefaults()
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
