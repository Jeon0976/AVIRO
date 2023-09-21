//
//  UIView+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/12.
//

import UIKit

fileprivate enum AniKeyPath: String {
    case position
}

extension UIView {
    func activeHshakeEffect() {
        let animation = CABasicAnimation(
            keyPath: AniKeyPath.position.rawValue
        )
        
        animation.duration = 0.02
        animation.repeatCount = 3
        animation.autoreverses = true
        
        animation.fromValue = NSValue(cgPoint: CGPoint(
            x: self.center.x - 2,
            y: self.center.y)
        )
        
        animation.toValue = NSValue(cgPoint: CGPoint(
            x: self.center.x + 2,
            y: self.center.y)
        )
        
        self.layer.add(
            animation,
            forKey: AniKeyPath.position.rawValue
        )
    }
 }
