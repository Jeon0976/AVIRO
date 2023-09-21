//
//  UIViewController+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/15.
//

import UIKit

extension UIViewController {
    func setupCustomBackButton(_ animatied: Bool = false) {
        let backButton = UIButton()
        
        backButton.setImage(
            UIImage.back,
            for: .normal
        )
        backButton.addTarget(
            self,
            action: #selector(customBackButtonTapped(_:)),
            for: .touchUpInside
        )
        backButton.frame = .init(
            x: 0,
            y: 0,
            width: 24,
            height: 24
        )
        
        backButton.tag = animatied ? 1 : 0
        
        let barButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func customBackButtonTapped(_ sender: UIButton) {
        let animated = sender.tag == 1
        
        navigationController?.popViewController(animated: animated)
    }
    
    func applyGradientToView(
        colors: [UIColor],
        locations: [NSNumber]? = nil,
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)
    ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.sublayers?.filter {
            $0 is CAGradientLayer
        }
        .forEach { $0.removeFromSuperlayer() }
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
