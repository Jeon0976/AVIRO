//
//  EnrollField.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/22.
//

import UIKit

class EnrollField: UITextField {
    private var horizontalPadding: CGFloat = 16
    private var verticalPadding: CGFloat = 13
    private var imageViewSize: CGFloat = 24
    private var buttonSize: CGFloat = 24
    private var buttonPadding: CGFloat = 7

    private var isAddLeftImage = false
    private var isAddRightButton = false
    
    var tappedPushViewButton: (() -> Void)?
    
    // MARK: Init 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 기본 Text Inset
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let inset = setTextInset()
            
        return bounds.inset(by: inset)
    }
    
    // MARK: Editing Text Inset
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let inset = setTextInset()
        
        return bounds.inset(by: inset)
    }
    
    // MARK: Set Configuration
    private func configuration() {
        self.textColor = .gray0
        self.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.backgroundColor = .gray6
        self.layer.cornerRadius = 10
    }
    
    // MARK: Text Edge Inset 값 설정
    /// Text Edge Inset 값 설정
    private func setTextInset() -> UIEdgeInsets {
        var inset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
        
        if isAddLeftImage {
            let leftInest = horizontalPadding + imageViewSize + buttonPadding
            
            inset.left = leftInest
        }
        
        if isAddRightButton {
            let rightInset = horizontalPadding + buttonSize + buttonPadding
            
            inset.right = rightInset
        }
        
        return inset
    }
    // MARK: Left Image 넣기
    /// Left Image 넣기
    func addLeftImage() {
        isAddLeftImage = !isAddLeftImage
        
        let image = UIImage(named: "Search")
        image?.withTintColor(.systemGray)
            
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: horizontalPadding, y: 0, width: imageViewSize, height: imageViewSize)
        
        let paddingWidth = horizontalPadding + buttonPadding + imageViewSize
        
        let paddingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: paddingWidth,
            height: imageViewSize)
        )
        
        paddingView.addSubview(imageView)
            
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func addRightPushViewControllerButton() {
        isAddRightButton = !isAddRightButton
        
        let image = UIImage(named: "PushView")
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        button.addTarget(self, action: #selector(rightPushViewButtonTapped), for: .touchUpInside)
        
        let paddingWidth = horizontalPadding + buttonPadding + buttonSize
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: buttonSize))
        
        paddingView.addSubview(button)
        
        self.rightView = paddingView
        self.rightViewMode = .always
    }

    @objc private func rightPushViewButtonTapped() {
        tappedPushViewButton?()
    }
    
    // MARK: Place Holder 값 넣기
    /// placeHolder 값 넣기
    func makePlaceHolder(_ placeHolder: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray3 ?? .systemGray4]
        )
    }
    
    // MARK: Make shadow
    func makeShadow(
        color: UIColor = .black,
        radious: CGFloat = 5,
        opacity: Float = 0.1,
        offset: CGSize = CGSize(width: 1, height: 3)
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radious
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
    }
}
