//
//  HaiViewController.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/10/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable

class HaiViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - StoryboardSceneBased
extension HaiViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.appDetail
}
