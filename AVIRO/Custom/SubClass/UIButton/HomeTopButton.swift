//
//  HomeTopButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/15.
//

import UIKit

final class HomeTopButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setAttribute() {
        self.backgroundColor = .gray7
        
        self.layer.cornerRadius = 20
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.layer.shadowColor = UIColor.black.cgColor

        self.isHidden = true
    }
}
