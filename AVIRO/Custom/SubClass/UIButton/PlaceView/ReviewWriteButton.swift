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
        backgroundColor = .gray7

        layer.cornerRadius = 27
        layer.borderColor = UIColor.main.cgColor
        layer.borderWidth = 2
    }
    
    func setButton(_ title: String = "지금 후기 작성하기",
                   _ image: UIImage? = UIImage.pencil
    ) {
        setTitle(title, for: .normal)
        setImage(image?.withTintColor(.main), for: .normal)
        
        setTitleColor(.main, for: .normal)
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
        
        contentEdgeInsets = .init(
            top: 14,
            left: 20,
            bottom: 14,
            right: 20
        )
    }
}
