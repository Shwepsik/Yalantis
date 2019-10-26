//
//  UIViewAnimations.swift
//  Yalantis_School
//
//  Created by Valerii on 10/23/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func shakeAnimation(delegate: CAAnimationDelegate) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.delegate = delegate
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
