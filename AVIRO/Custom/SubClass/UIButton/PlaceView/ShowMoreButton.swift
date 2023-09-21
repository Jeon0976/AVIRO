//
//  ShowMoreButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/17.
//

import UIKit

final class ShowMoreButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setButton(_ title: String) {
        self.backgroundColor = .gray7

        self.setTitle(title, for: .normal)
        self.setTitleColor(.gray2, for: .normal)
        self.titleLabel?.font = CFont.font.medium14
        
        self.setImage(UIImage(named: "More"), for: .normal)
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 7,
            bottom: 0,
            right: 0
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 5,
            bottom: 0,
            right: 7
        )
        
        self.semanticContentAttribute = .forceRightToLeft
    }
}
