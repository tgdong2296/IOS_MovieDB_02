//
//  UIViewExtension.swift
//  TheMoviesReal
//
//  Created by Hai on 7/24/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit

extension UIView {
    func setGradientForUIView(_ colors: UIColor..., isCorner: Bool) {
        let gradient = CAGradientLayer()
        var gradientColors: [CGColor] = []
        for color in colors {
            gradientColors.append(color.cgColor)
        }
        gradient.colors = gradientColors
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        if isCorner {
            gradient.cornerRadius = 10
        }
        layer.insertSublayer(gradient, at: 0)
    }
    
    func dropShadow(padding: CGFloat) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        let screenSize = UIScreen.main.bounds
        let viewBound = CGRect(x: 0, y: 0, width: screenSize.width - padding, height: self.bounds.height)
        layer.shadowPath = UIBezierPath(roundedRect: viewBound, cornerRadius: self.layer.cornerRadius).cgPath
    }
}
