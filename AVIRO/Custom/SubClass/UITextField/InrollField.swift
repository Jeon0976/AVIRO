//
//  InrollField.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/20.
//

import UIKit

class InrollTextField: UITextField {
    private let inset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBorder()
        
        self.textColor = .mainTitle
        self.frame.size.height = 53
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureBorder() {
        self.layer.borderColor = UIColor.separateLine?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
    
    // clearButton의 위치와 크기를 고려해 inset 삽입
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }

    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? .white : .separateLine
        }
    }
    
    
    func makeCustomPlaceHolder(_ text: String) {
        let placeholderText = NSAttributedString(string: text, attributes: [.foregroundColor: UIColor.subTitle!])
        self.attributedPlaceholder = placeholderText
    }
}
