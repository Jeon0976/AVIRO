//
//  SearchField.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/31.
//

import UIKit

final class SearchField: UITextField {
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 15
    private let buttonPadding: CGFloat = 10
    private let buttonSize: CGFloat = 24
    
    private lazy var textInset = UIEdgeInsets(
        top: verticalPadding,
        left: horizontalPadding + buttonSize + buttonPadding,
        bottom: verticalPadding,
        right: horizontalPadding + buttonSize + buttonPadding
    )
    
    private var leftButton = UIButton()
    private var rightButton = UIButton()
    
    private var changedLeftButton = false
    private var isNotChangedImageBeforeNextAction = false
    
    var didTappedLeftButton: (() -> Void)?
    
    var rightButtonHidden = false {
        didSet {
            rightView?.isHidden = rightButtonHidden
        }
    }
    
    private lazy var paddingWidth = horizontalPadding + buttonSize + buttonPadding
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration()
        makeLeftButton()
        makeRightButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func textRect(
        forBounds bounds: CGRect
    ) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    override func editingRect(
        forBounds bounds: CGRect
    ) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    private func configuration() {
        textColor = .keywordBlue
        font = CFont.font.medium18
        backgroundColor = .gray6
        layer.cornerRadius = 10
    }
    
    private func makeLeftButton() {
        let image = UIImage.searchIcon.withRenderingMode(.alwaysTemplate)
        
        leftButton.setImage(image, for: .normal)
        leftButton.tintColor = .gray2
        leftButton.frame = .init(
            x: horizontalPadding,
            y: 0,
            width: buttonSize,
            height: buttonSize
        )
        leftButton.addTarget(
            self,
            action: #selector(leftButtonTapped),
            for: .touchUpInside
        )
        
        let paddingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: paddingWidth,
            height: buttonSize)
        )
        
        paddingView.addSubview(leftButton)
        
        leftView = paddingView
        leftViewMode = .always
    }
    
    func changeLeftButton() {
        let changedImage = UIImage.back.withRenderingMode(.alwaysTemplate)
        leftButton.setImage(changedImage, for: .normal)
        
        changedLeftButton = true
    }
    
    func initLeftButton() {
        let initImage = UIImage.searchIcon.withRenderingMode(.alwaysTemplate)
        leftButton.setImage(initImage, for: .normal)
    }
    
    @objc func leftButtonTapped(_ sender: UIButton) {
        guard changedLeftButton == true else {
            return
        }
        
        changedLeftButton = false
        self.didTappedLeftButton?()
    }
    
    private func makeRightButton() {
        let image = UIImage.closeCircle.withRenderingMode(.alwaysTemplate)
        
        rightButton.setImage(image, for: .normal)
        rightButton.tintColor = .gray2
        rightButton.frame = .init(
            x: horizontalPadding,
            y: 0,
            width: buttonSize,
            height: buttonSize
        )
        rightButton.addTarget(
            self,
            action: #selector(rightButtonTapped),
            for: .touchUpInside
        )
        
        let paddingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: paddingWidth,
            height: buttonSize)
        )
        
        paddingView.addSubview(rightButton)
        
        rightView = paddingView
        rightViewMode = .always
    }
    
    @objc func rightButtonTapped(_ sender: UIButton) {
        self.text = ""
        self.rightButtonHidden = true
    }
    
    func makePlaceHolder(_ placeHolder: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray3]
        )
    }
}
