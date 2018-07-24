//
//  ErrorResponse.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/23/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import ObjectMapper

class ErrorResponse: Mappable {
    var statusCode: String?
    var statusMessage: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        statusCode <- map["status_code"]
        statusMessage <- map["status_message"]
    }
}
