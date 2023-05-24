//
//  Config.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit

extension UIButton {
    // MARK: UIButton Image size
    func customImageConfig(_ nomalImage: String, _ selectedImage: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .light)
        self.setImage(UIImage(systemName: nomalImage,
                              withConfiguration: config),
                    for: .normal
        )
        self.setImage(UIImage(systemName: selectedImage,
                              withConfiguration: config),
                      for: .highlighted
        )
    }
    
    // MARK: vegan select button
    func makeVeganSelectButton(_ image: String, _ title: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 34)
        self.setImage(UIImage(systemName: image,
                              withConfiguration: config),
                      for: .normal)
        self.setTitle(title, for: .normal)
        
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        self.contentVerticalAlignment = .center
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3.0
        self.backgroundColor = .white
    }
}

extension String {
    // MARK: Text m/k 변환
    func convertDistanceUnit() -> String {
        guard let number = Int(self) else { return "" }
        
        if number >= 1000 {
           return "\(number / 1000)k"
        } else {
           return "\(number)m"
        }
    }
}

class InrollTextField: UITextField {
    // MARK: TextField Inset 섫정
    private let commonInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let clearButtonOffset: CGFloat = 5
    private let clearButtonLeftPadding: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBorder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureBorder()
    }

    private func configureBorder() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }
    
    // clearButton의 위치와 크기를 고려해 inset 삽입
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let clearButtonWidth = clearButtonRect(forBounds: bounds).width
        let editingInsets = UIEdgeInsets(
            top: commonInsets.top,
            left: commonInsets.left,
            bottom: commonInsets.bottom,
            right: clearButtonWidth + clearButtonOffset + clearButtonLeftPadding
        )
        
        return bounds.inset(by: editingInsets)
    }
    
    // clearButtonOffset만큼 x축 이동
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var clearButtonRect = super.clearButtonRect(forBounds: bounds)
        clearButtonRect.origin.x -= clearButtonOffset
        return clearButtonRect
    }
    
    func customClearButton() {
        let customClearButton = UIButton(type: .custom)
        customClearButton.setImage(
            UIImage(systemName: "xmark.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal)
        customClearButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        self.rightView = customClearButton
        self.rightViewMode = .whileEditing
    }
}

class EdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
