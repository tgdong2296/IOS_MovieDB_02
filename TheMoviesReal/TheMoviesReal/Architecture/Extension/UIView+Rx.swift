//
//  UIView+Rx.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 7/30/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import MBProgressHUD
import RxSwift
import RxCocoa
import Cosmos
import youtube_ios_player_helper

extension Reactive where Base: YTPlayerView {
    var videoID: Binder<String> {
        return Binder(base) { view, videoID in
            view.load(withVideoId: videoID, playerVars: ["playsinline": 1])
        }
    }
}

extension Reactive where Base: CosmosView {
    var rate: Binder<Float> {
        return Binder(base) { view, rate in
            view.rating = Double(rate / 2)
            view.text = "(\(rate))"
        }
    }
}
