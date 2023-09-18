//
//  MainField.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/04.
//

import UIKit

class MainField: UITextField {
    private var horizontalPadding: CGFloat = 16
    private var buttonPadding: CGFloat = 7
    private var verticalPadding: CGFloat = 15
    private var imageViewSize: CGFloat = 24
        
    // MARK: Init 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration()
        addLeftImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
        self.font = .pretendard(size: 18, weight: .medium)
        self.backgroundColor = .gray6
        self.layer.cornerRadius = 10
    }
    
    // MARK: Text Edge Inset 값 설정
    /// Text Edge Inset 값 설정
    private func setTextInset() -> UIEdgeInsets {
        let inset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding + imageViewSize + buttonPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
        return inset
    }
    
    // MARK: Left Image 넣기
    /// Left Image 넣기
    private func addLeftImage() {
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

    // MARK: Place Holder 값 넣기
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
