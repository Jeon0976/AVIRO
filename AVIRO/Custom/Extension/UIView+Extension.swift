//
//  UIView+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/12.
//

import UIKit

extension UIView {
    func activeShakeAfterNoSearchData() {
        let animation = CABasicAnimation(keyPath: "position")
        
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 3, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 3, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
 }
