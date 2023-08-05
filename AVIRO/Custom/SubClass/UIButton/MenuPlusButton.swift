//
//  MenuPlusButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/26.
//

import UIKit

final class MenuPlusButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    private func setupButton() {
        layer.cornerRadius = 27
        backgroundColor = .gray7
        layer.borderColor = UIColor.main?.cgColor
        layer.borderWidth = 2
    }
    
    func setButton(_ title: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor.main!
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        
        setAttributedTitle(attributedTitle, for: .normal)
        
        setImage(UIImage(named: "Plus"), for: .normal)
        
        imageView?.contentMode = .scaleAspectFit
        semanticContentAttribute = .forceLeftToRight
        
        imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        
        contentEdgeInsets = .init(top: 14.5, left: 32, bottom: 14.5, right: 32)
    }
}
