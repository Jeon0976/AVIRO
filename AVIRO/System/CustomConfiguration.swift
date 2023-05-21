//
//  Config.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit

extension UIButton {
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
}

// MARK: Inset
class InsetTextField: UITextField {
    private let commonInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    private let clearButtonOffset: CGFloat = 5
    private let clearButtonLeftPadding: CGFloat = 5
    
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
}
