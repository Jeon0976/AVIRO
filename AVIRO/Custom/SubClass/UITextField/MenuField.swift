//
//  MenuField.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/25.
//

import UIKit

protocol MenuFieldDelegate: AnyObject {
    func menuFieldDIdTapDotsButton(_ alertController: UIAlertController)
}

final class MenuField: UITextField {
    private var horizontalPadding: CGFloat = 16
    private var verticalPadding: CGFloat = 12
    private var buttonPadding: CGFloat = 7
    private var buttonSize: CGFloat = 24
    
    private var isAddRightButton = false
    
    weak var buttonDelegate: MenuFieldDelegate?
    
    var variblePriceChanged: ((String) -> Void)?

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
    
    func addRightButton() {
        isAddRightButton = !isAddRightButton
        
        let image = UIImage(named: "Dots")?.withRenderingMode(.alwaysTemplate)
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(makeAlert), for: .touchUpInside)
        button.tintColor = .gray2

        button.frame = .init(x: horizontalPadding, y: 0, width: buttonSize, height: buttonSize)
        
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
    
    @objc private func makeAlert() {
        let alertController = UIAlertController(title: "변동 선택", message: "", preferredStyle: .alert)
        var action = UIAlertAction()
        
        if self.text == "변동" {
            action = UIAlertAction(title: "변동취소", style: .default) { _ in
                let text = ""
                self.text = text
                self.variblePriceChanged?(text)
            }
        } else {
            action = UIAlertAction(title: "변동", style: .default) { _ in
                let text = "변동"
                self.text = "변동"
                self.variblePriceChanged?(text)
            }
        }
        let cancel = UIAlertAction(title: "닫기", style: .destructive)
        
        alertController.addAction(action)
        alertController.addAction(cancel)
        
        buttonDelegate?.menuFieldDIdTapDotsButton(alertController)
    }
}
