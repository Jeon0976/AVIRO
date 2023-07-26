//
//  TutorialResButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/08.
//

import UIKit

// Enable 일때 설정 다시
final class BottomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title = title else {
            super.setTitle(title, for: state)
            return
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 19, weight: .semibold),
            .foregroundColor: UIColor.white
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(attributedTitle, for: state)
    }
    
    private func setupButton() {
        self.layer.cornerRadius = 25
        self.contentEdgeInsets = UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25)
        self.clipsToBounds = true
        self.backgroundColor = .allVegan
    }
     
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor.allVegan?.cgColor ?? UIColor.purple.cgColor,
            UIColor.allVeganGradient?.cgColor ?? UIColor.blue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 26
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeGradient() {
        self.layer.sublayers?.first(where: { $0 is CAGradientLayer })?.removeFromSuperlayer()
    }
    
    override var isEnabled: Bool {
         didSet {
             self.backgroundColor = isEnabled ? .allVegan : .subTitle
         }
     }
 }
