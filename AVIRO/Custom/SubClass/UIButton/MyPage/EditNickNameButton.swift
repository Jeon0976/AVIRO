//
//  EditNicNameButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/08.
//

import UIKit

final class EditNickNameButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func makeButton(_ text: String ) {
        self.setTitle(text, for: .normal)
        self.setImage(UIImage.smallPushView, for: .normal)
        self.titleLabel?.font = CFont.font.regular14
        self.setTitleColor(.gray2, for: .normal)
        
        self.semanticContentAttribute = .forceRightToLeft
    }
}
