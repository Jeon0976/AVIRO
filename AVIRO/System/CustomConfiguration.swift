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
        self.setImage(UIImage(named: "plusButton"), for: .normal)
        self.setImage(UIImage(named: "plusButton"), for: .highlighted)

    }
}

// MARK: Select Vegan Button 설정
class SelectVeganButton: UIButton {
    func makeVeganSelectButton(_ nomal: String, _ title: String) {
        self.setTitle(title, for: .normal)

        self.setImage(UIImage(named: nomal), for: .normal)
        self.setTitleColor(ColorsList1, for: .normal)
        
        self.imageView?.contentMode = .scaleAspectFit
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        self.semanticContentAttribute = .forceLeftToRight
        self.layer.borderColor = ColorsList1.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 16
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let imageView = imageView, let titleLabel = titleLabel {
            let spacing: CGFloat = 10.0
            let imageSize = imageView.frame.size
            let titleSize = titleLabel.bounds.size

            titleEdgeInsets = UIEdgeInsets(top: (spacing + imageSize.height),
                                            left: -(imageSize.width),
                                            bottom: 10.0,
                                            right: 0.0)

            imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing),
                                           left: 0.0,
                                           bottom: 0.0,
                                           right: -titleSize.width)

            let totalHeight = imageSize.height + titleSize.height + spacing
            self.contentEdgeInsets = UIEdgeInsets(
                top: (bounds.size.height - totalHeight) / 2,
                left: 0,
                bottom: (bounds.size.height - totalHeight) / 2,
                right: 0
            )
        }
    }
}

class ReportButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? ColorsList4 : ColorsList1
        }
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

// MARK: Inroll TextField 설정
class InrollTextField: UITextField {
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
        self.layer.borderColor = ColorsList1.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
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
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? .white : ColorsList1
        }
    }
    
    func customClearButton() {
        let customClearButton = UIButton(type: .custom)
        customClearButton.setImage(
            UIImage(named: "Close"),
            for: .normal)
        customClearButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        self.rightView = customClearButton
        self.rightViewMode = .whileEditing
    }
    
}

// MARK: comment TextField 설정
class CommentsTextField: UITextField {
    private let commonInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let clearButtonOffset: CGFloat = 5
    private let clearButtonLeftPadding: CGFloat = 5
    
    private let topBorder: CALayer

    override init(frame: CGRect) {
        self.topBorder = CALayer()

        super.init(frame: frame)
        
        topBorder.borderColor = UIColor.lightGray.cgColor
        topBorder.borderWidth = 1.0

        self.layer.addSublayer(topBorder)
    }

    required init?(coder aDecoder: NSCoder) {
        self.topBorder = CALayer()

        super.init(coder: aDecoder)
                
        topBorder.borderColor = UIColor.lightGray.cgColor
        topBorder.borderWidth = 1.0

        self.layer.addSublayer(topBorder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topBorder.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1.0)
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
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? .white : ColorsList1
        }
    }
    
    func customClearButton() {
        let customClearButton = UIButton(type: .custom)
        customClearButton.setImage(
            UIImage(named: "Close"),
            for: .normal)
        customClearButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        self.rightView = customClearButton
        self.rightViewMode = .whileEditing
    }
    
}

class TitleTextField: UITextField {
    private let commonInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage()
        shadowAndborder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setImage()
        shadowAndborder()
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }
    
    func setImage() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Search"), for: .normal)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: button.frame.width + 16, height: button.frame.height))
        container.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
        
        self.leftView = container
        self.leftViewMode = .always
        self.leftView?.isUserInteractionEnabled = false
    }
    
    func shadowAndborder() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.25
        
        self.layer.cornerRadius = 16

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

class PaddingLabel: UILabel {

    var topInset: CGFloat = 10.0
    var bottomInset: CGFloat = 10.0
    var leftInset: CGFloat = 16.0
    var rightInset: CGFloat = 16.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

// MARK: Color Custom
let ColorsList1 = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
let ColorsList2 = UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)
let ColorsList3 = UIColor(red: 6/255, green: 23/255, blue: 37/255, alpha: 1)
let ColorsList4 = UIColor(red: 226/255, green: 242/255, blue: 99/255, alpha: 1)
let ColorsList5 = UIColor(red: 160/255, green: 81/255, blue: 234/255, alpha: 1)

let PonitColor1 = UIColor(red: 174/255, green: 227/255, blue: 23/255, alpha: 1)
let PonitColor2 = UIColor(red: 160/255, green: 81/255, blue: 234/255, alpha: 1)
let PonitColor3 = UIColor(red: 70/255, green: 155/255, blue: 255/255, alpha: 1)
