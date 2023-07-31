//
//  MenuField.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/25.
//

import UIKit

final class MenuField: UITextField {
    private var horizontalPadding: CGFloat = 16
    private var verticalPadding: CGFloat = 12
    private var buttonPadding: CGFloat = 10
    private var buttonSize: CGFloat = 24
    
    private var isAddRightButton = false
        
    var variblePriceChanged: ((String) -> Void)?
    
    override var text: String? {
        didSet {
            updateButtonMenu()
        }
    }

    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? .gray6 : .gray5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let inset = setTextInset()
        
        return bounds.inset(by: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let inset = setTextInset()
        
        return bounds.inset(by: inset)
    }
    
    private func configuration() {
        textColor = .gray0
        font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backgroundColor = .gray6
        layer.cornerRadius = 10
    }
    
    private func setTextInset() -> UIEdgeInsets {
        var inset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
        
        if isAddRightButton {
            let rightInest = horizontalPadding + buttonSize + buttonPadding
            
            inset.right = rightInest
            
            return inset
        }
        
        return inset
    }
    
    func makePlaceHolder(_ placeHolder: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray3 ?? .systemGray4]
        )
    }
    
    // MARK: Right Button 생성
    func addRightButton() {
        isAddRightButton = !isAddRightButton
        
        let image = UIImage(named: "Dots")?.withRenderingMode(.alwaysTemplate)
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = .gray2
        button.frame = .init(x: horizontalPadding, y: 0, width: buttonSize, height: buttonSize)
        
        button.menu = setButtonMenu()

        button.showsMenuAsPrimaryAction = true
        
        let paddingWidth = horizontalPadding + buttonSize + buttonPadding
        
        let paddingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: paddingWidth,
            height: buttonSize)
        )
        
        paddingView.addSubview(button)
        
        rightView = paddingView
        rightViewMode = .always
    }
    
    // MARK: text 데이터에 따른 '변동'데이터 로직 처리
    private func updateButtonMenu() {
        guard let button = rightView?.subviews.first as? UIButton else {
            return
        }

        button.menu = setButtonMenu()
    }
    
    // MARK: SetButton Menu 
    private func setButtonMenu() -> UIMenu {
        var variablePrice: UIAction

        if self.text == "변동" {
            variablePrice = UIAction(title: "변동취소", handler: { [weak self] _ in
                self?.text = ""
                self?.variblePriceChanged?("")
            })
        } else {
            variablePrice = UIAction(title: "변동", handler: { [weak self] _ in
                self?.text = "변동"
                self?.variblePriceChanged?("변동")
            })
        }

        let cancel = UIAction(title: "취소", attributes: .destructive) { _ in }
        let menu = UIMenu(title: "변동가격",
                          identifier: nil,
                          options: .displayInline,
                          children: [variablePrice, cancel]
        )

        return menu
    }
}
