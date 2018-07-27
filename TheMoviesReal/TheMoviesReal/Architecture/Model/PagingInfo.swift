//
//  PagingInfo.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/26/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation

struct PagingInfo<T> {
    let page: Int
    let items: [T]
}
