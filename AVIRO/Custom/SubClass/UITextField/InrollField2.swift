//
//  InrollField2.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/22.
//

import UIKit

class InrollField2: UITextField {
    var leftPadding = CGFloat(16)
    var buttonPadding = CGFloat(7)
    var verticalPadding =  CGFloat(13)
    var imageViewWidth: CGFloat = 24
    
    var isAddLeftImage = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        self.textColor = .registrationColor
        self.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.backgroundColor = .backField
        self.layer.cornerRadius = 10
    }
    
    func addLeftImage() {
        isAddLeftImage = !isAddLeftImage
        
        let image = UIImage(named: "Search")
        image?.withTintColor(.systemGray)
            
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: leftPadding, y: 0, width: imageViewWidth, height: imageViewWidth)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding + buttonPadding + imageViewWidth , height: imageViewWidth))
        paddingView.addSubview(imageView)
            
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if isAddLeftImage {
            let leftInest = leftPadding + imageViewWidth + buttonPadding
            let insetBounds = bounds.inset(by: UIEdgeInsets(top: verticalPadding, left: leftInest, bottom: verticalPadding, right: leftPadding))
            return insetBounds
        } else {
            let insetBounds = bounds.inset(by: UIEdgeInsets(top: verticalPadding, left: leftPadding, bottom: verticalPadding, right: leftPadding))
            return insetBounds
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if isAddLeftImage {
            let leftInest = leftPadding + imageViewWidth + buttonPadding
            let insetBounds = bounds.inset(by: UIEdgeInsets(top: verticalPadding, left: leftInest, bottom: verticalPadding, right: leftPadding))
            return insetBounds
        } else {
            let insetBounds = bounds.inset(by: UIEdgeInsets(top: verticalPadding, left: leftPadding, bottom: verticalPadding, right: leftPadding))
            return insetBounds
        }
    }

    
    func makePlaceHolder(_ placeHolder: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.registrationPlaceHolder!]
        )
    }

}

