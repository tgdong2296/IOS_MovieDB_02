//
//  AbouAppViewController.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/9/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Cards

class AboutAppViewController: UIViewController {
    private struct Constants {
        static let trainerTitle = "Trainer"
        static let traineeTitle = "Trainee"
        static let trainerName = "Doãn Văn Toản"
        static let trainneDong = "Trịnh Giang Đông"
        static let traineeHai = "Trịnh Hoàng Hải"
        static let viewWidth = UIScreen.main.bounds.width - 40
        static let viewHeight = (UIScreen.main.bounds.width - 40) * 3 / 2
    }
    
    @IBOutlet private weak var dropWaterView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var trainerView: UIView!
    @IBOutlet private weak var traineeOneView: UIView!
    @IBOutlet private weak var traineeTwoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCardView()
    }
    
    private func configCardView() {
        let trainerCard = getCardView(image: #imageLiteral(resourceName: "img_trainer"), title: Constants.trainerTitle, name: Constants.trainerName)
        let trainerVC = TrainerDetailViewController.instantiate()
        trainerCard.shouldPresent(trainerVC, from: self, fullscreen: true)
        
        let traineeDongCard = getCardView(image: #imageLiteral(resourceName: "Trinh Giang Dong"), title: Constants.traineeTitle, name: Constants.trainneDong)
        let dongVC = DongViewController.instantiate()
        traineeDongCard.shouldPresent(dongVC, from: self, fullscreen: true)
        
        let traineeHaiCard = getCardView(image: #imageLiteral(resourceName: "Trinh Hoang Hai"), title: Constants.traineeTitle, name: Constants.traineeHai)
        let haiVC = HaiViewController.instantiate()
        traineeHaiCard.shouldPresent(haiVC, from: self, fullscreen: true)
        
        trainerView.addSubview(trainerCard)
        traineeOneView.addSubview(traineeDongCard)
        traineeTwoView.addSubview(traineeHaiCard)
    }
}

// MARK: - CardsPlayer library
extension AboutAppViewController {
    func getCardView(image backgroundImage: UIImage, title: String, name: String) -> CardArticle {
        let card = CardArticle(frame: CGRect(x: 0, y: 0, width: Constants.viewWidth, height: Constants.viewHeight))
        card.backgroundImage = backgroundImage
        card.title = ""
        card.category = ""
        card.subtitle = name
        card.subtitleSize = 30
        card.textColor = UIColor.cardTitleColor
        card.hasParallax = true
        return card
    }
}
