//
//  HomeMapReferButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/15.
//

import UIKit

final class HomeMapReferButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setAttribute() {
        self.backgroundColor = .gray7
        
        self.layer.cornerRadius = 15
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = .init(width: 1, height: 3)
        self.layer.shadowColor = UIColor.black.cgColor

        self.contentEdgeInsets = UIEdgeInsets(
            top: 12,
            left: 12,
            bottom: 12,
            right: 12
        )
    }
}
