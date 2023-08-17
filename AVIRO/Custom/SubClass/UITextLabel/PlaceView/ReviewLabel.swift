//
//  ReviewLabel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/17.
//

import UIKit

final class ReviewLabel: UILabel {
    
    private var topInset: CGFloat = 10.0
    private var bottomInset: CGFloat = 10.0
    private var leftInset: CGFloat = 16.0
    private var rightInset: CGFloat = 16.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    private func setAttribute() {
        self.font = .systemFont(ofSize: 15, weight: .medium)
        self.textColor = .gray0
        self.backgroundColor = .gray6 
    }
    
    func setLabel(_ text: String) {
        
    }
}
