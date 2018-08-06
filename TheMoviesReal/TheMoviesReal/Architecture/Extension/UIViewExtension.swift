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
    
    func dropShadow(width: CGFloat, height: CGFloat) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        let viewBound = CGRect(x: 0, y: 0, width: width, height: height)
        layer.shadowPath = UIBezierPath(roundedRect: viewBound, cornerRadius: self.layer.cornerRadius).cgPath
    }
}
