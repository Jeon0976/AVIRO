//
//  ReviewWriteButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/17.
//

import UIKit

final class ReviewWriteButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setAttribute() {        
        layer.cornerRadius = 24
        layer.borderColor = UIColor.main.cgColor
        layer.borderWidth = 2
        self.backgroundColor = .main
        self.clipsToBounds = true
    }
    
    func setButton(_ title: String = "지금 후기 작성하기",
                   _ image: UIImage? = UIImage.pencil
    ) {
        setTitle(title, for: .normal)
        setImage(image?.withTintColor(.gray7), for: .normal)
        
        setTitleColor(.gray7, for: .normal)
        titleLabel?.font = CFont.font.semibold16
        
        semanticContentAttribute = .forceLeftToRight
        
        imageEdgeInsets = .init(
            top: 0,
            left: 0,
            bottom: 0,
            right: 10
        )
        titleEdgeInsets = .init(
            top: 0,
            left: 10,
            bottom: 0,
            right: 0
        )
    }
}
