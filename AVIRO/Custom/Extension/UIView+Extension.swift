//
//  UIView+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/12.
//

import UIKit

private enum AniKeyPath: String {
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
    
    func activeExpansion(
        from startingFrame: CGRect,
        to targetView: UIView,
        completion: @escaping () -> Void
    ) {
        let snapshot = self.snapshotView(afterScreenUpdates: true)
        snapshot?.frame = startingFrame

        guard let snapshot = snapshot else { return }
        targetView.addSubview(snapshot)

        let targetScaleX = targetView.frame.width / startingFrame.width
        let targetScaleY = targetView.frame.height / startingFrame.height
        
        UIView.animate(withDuration: 0.15, animations: {
            snapshot.transform = CGAffineTransform(scaleX: targetScaleX, y: targetScaleY)
            snapshot.center = targetView.center

        }, completion: { _ in
            completion()
            snapshot.removeFromSuperview()
        })
    }
}
