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
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    // MARK: Configuration
    private func configuration() {
        textColor = .keywordBlue
        font = .pretendard(size: 18, weight: .medium)
        backgroundColor = .gray6
        layer.cornerRadius = 10
    }
    
    // MARK: Make left Button
    private func makeLeftButton() {
        let image = UIImage(named: "Search")?.withRenderingMode(.alwaysTemplate)
        
        leftButton.setImage(image, for: .normal)
        leftButton.tintColor = .gray2
        leftButton.frame = .init(x: horizontalPadding, y: 0, width: buttonSize, height: buttonSize)
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        
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
    
    // MARK: Left button 바꾸기
    func changeLeftButton() {
        let changedImage = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        leftButton.setImage(changedImage, for: .normal)
        
        changedLeftButton = true
    }
    
    // MARK: Left Button 원 상태로 돌리기
    func initLeftButton() {
        let initImage = UIImage(named: "Search")?.withRenderingMode(.alwaysTemplate)
        leftButton.setImage(initImage, for: .normal)
    }
    
    // MARK: Left Button이 바뀌었을 때만 활성화
    @objc func leftButtonTapped(_ sender: UIButton) {
        guard changedLeftButton == true else {
            return
        }
        
        changedLeftButton = false
        self.didTappedLeftButton?()
    }
    
    // MARK: Make Right Button
    private func makeRightButton() {
        let image = UIImage(named: "X-Circle")?.withRenderingMode(.alwaysTemplate)
        
        rightButton.setImage(image, for: .normal)
        rightButton.tintColor = .gray2
        rightButton.frame = .init(x: horizontalPadding, y: 0, width: buttonSize, height: buttonSize)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
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
    
    // MARK: Right Button 클릭 시
    @objc func rightButtonTapped(_ sender: UIButton) {
        self.text = ""
        self.rightButtonHidden = true
    }
    
    // MARK: Place Holder 값 넣기
    func makePlaceHolder(_ placeHolder: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray3 ?? .systemGray4]
        )
    }
}
