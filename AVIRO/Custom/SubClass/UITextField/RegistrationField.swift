//
//  RegistrationField.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/09.
//

import UIKit

class RegistrationField: UITextField {
    private var horizontalPadding: CGFloat = 20
    private var verticalPadding: CGFloat = 13
    private var imageViewSize: CGFloat = 24
    private var buttonSize: CGFloat = 24
    private var buttonPadding: CGFloat = 7
    
    private var rightButton = UIButton()

    private let inset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    private let rightButtonInset = CGFloat(5)
        
    var isPossible: Bool? {
        didSet {
            if let isPossible = isPossible {
                self.backgroundColor = isPossible ? .bgNavy : .bgRed
                self.rightView = makeRightView(isPossible)
                self.rightViewMode = .always
            } else {
                self.backgroundColor = .gray6
                self.rightView = nil
            }
        }
    }
    
    var rightButtonHidden = false {
        didSet {
            rightView?.isHidden = rightButtonHidden
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
        self.textColor = .gray0
        self.layer.cornerRadius = 25
        self.backgroundColor = .gray6
        self.rightViewMode = .unlessEditing
        self.font = .pretendard(size: 18, weight: .medium)
    }
    
    private func makeRightView(_ isPossible: Bool) -> UIView {
        let image = isPossible ?
        UIImage(named: "CheckArt")?.withTintColor(.main!)
        :
        UIImage(named: "ErrorArt")
        
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
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray3 ?? UIColor.lightGray]
        )
    }
    
    func addRightCancelButton() {
        let image = UIImage(named: "X-Circle")?.withRenderingMode(.alwaysTemplate)
        
        rightButton.setImage(image, for: .normal)
        rightButton.tintColor = .gray2
        rightButton.frame = .init(x: 0, y: 0, width: buttonSize, height: buttonSize)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
                
        let paddingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 40,
            height: 24)
        )
        
        paddingView.addSubview(rightButton)
        
        rightView = paddingView
        rightViewMode = .always
    }
    
    // MARK: Right Button 클릭 시
    @objc func rightButtonTapped(_ sender: UIButton) {
        self.text = ""
        self.rightButtonHidden = true
    }
}
