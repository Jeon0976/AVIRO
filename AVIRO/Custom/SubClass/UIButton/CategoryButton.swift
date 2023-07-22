//
//  CategoryButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/22.
//
//
import UIKit

final class CategoryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButton(_ title: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.registrationColor!
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        
        setAttributedTitle(attributedTitle, for: .normal)
        
        setImage(UIImage(named: "EmptyFrame"), for: .normal)
        setImage(UIImage(named: "Frame"), for: .selected)
        
        self.imageView?.contentMode = .scaleAspectFit
        self.semanticContentAttribute = .forceLeftToRight
        self.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 7)
        self.titleEdgeInsets = .init(top: 0, left: 7, bottom: 0, right: 0)
    }
}
