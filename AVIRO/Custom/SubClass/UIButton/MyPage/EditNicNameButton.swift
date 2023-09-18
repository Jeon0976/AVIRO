//
//  EditNicNameButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/08.
//

import UIKit

final class EditNicNameButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func makeButton(_ text: String ) {
        self.setTitle(text, for: .normal)
        self.setImage(UIImage(named: "SmallPushView"), for: .normal)
        self.titleLabel?.font = .pretendard(size: 14, weight: .regular)
        self.setTitleColor(.gray2, for: .normal)
        
        self.semanticContentAttribute = .forceRightToLeft
    }
}
