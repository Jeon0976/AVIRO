//
//  NoResultLabel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/19.
//

import UIKit

final class NoResultLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupAttribute() {
        self.textColor = .gray2
        self.numberOfLines = 2
        self.font = .pretendard(size: 15, weight: .medium)
    }
    
    func setupLabel(_ value: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25
        
        self.attributedText = NSMutableAttributedString(
            string: value,
            attributes:
                [NSAttributedString.Key.kern: -0.45,
                 NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
        )
        self.textAlignment = .center
    }
}
