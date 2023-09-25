//
//  TutorialTopLabel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/25.
//

import UIKit

final class TutorialTopLabel: UILabel {
    private var topInset: CGFloat = 8.0
    private var bottomInset: CGFloat = 8.0
    private var leftInset: CGFloat = 12.0
    private var rightInset: CGFloat = 12.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(
            top: topInset,
            left: leftInset,
            bottom: bottomInset,
            right: rightInset
        )
        
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        return CGSize(
            width: size.width + leftInset + rightInset,
            height: size.height + topInset + bottomInset
        )
    }
    
    private func setAttribute() {
        self.font = CFont.font.heavy17
        self.backgroundColor = UIColor(red: 0.87, green: 0.95, blue: 1, alpha: 1)
        self.layer.cornerRadius = 10
        self.textAlignment = .center
        self.textColor = .main
        self.clipsToBounds = true
    }
}
