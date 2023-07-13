//
//  RegistrationField.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/09.
//

import UIKit

class RegistrationField: UITextField {
    private let inset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    private let rightButtonInset = CGFloat(5)
    
    var didTapBackspace: (() -> Void)?
    
    var isPossible: Bool? {
        didSet {
            if let isPossible = isPossible {
                self.backgroundColor = isPossible ? .possibleColor : .impossibleColor
                self.rightView = makeRightView(isPossible)
                self.rightViewMode = .always
            } else {
                self.backgroundColor = .backField
                self.rightView = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // text Inset
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
    
    private func configuration() {
        self.textColor = .registrationColor
        self.layer.cornerRadius = 26
        self.backgroundColor = .backField
        self.rightViewMode = .unlessEditing
    }
    
    private func makeRightView(_ isPossible: Bool) -> UIView {
        let image = isPossible ? UIImage(named: Image.Registration.check) : UIImage(named: Image.Registration.xCheck)
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        paddingView.addSubview(imageView)
    
        return paddingView
    }
    
    func makePlaceHolder(_ placeHolder: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.registrationPlaceHolder]
        )
    }
}
