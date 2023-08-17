//
//  EditButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/17.
//

import UIKit

final class EditButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setButton(_ title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.changeButton, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
        self.setImage(UIImage(named: "Edit"), for: .normal)
        
        self.backgroundColor = .gray7

        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        self.semanticContentAttribute = .forceLeftToRight
    }
}
