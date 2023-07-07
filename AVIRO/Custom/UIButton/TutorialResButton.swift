//
//  TutorialResButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/08.
//

import UIKit

class TutorialResButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
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
        self.backgroundColor = .subTitle
        self.layer.cornerRadius = 26
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .allVegan
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25)
        self.configuration = configuration
        self.clipsToBounds = true
    }
    
    override var isEnabled: Bool {
         didSet {
             var configuration = self.configuration ?? UIButton.Configuration.filled()
             
             configuration.baseBackgroundColor = isEnabled ? .allVegan : .clear
             
             self.updateConfiguration()
         }
     }
 }
