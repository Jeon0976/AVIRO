//
//  VeganOptionButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/23.
//

import UIKit

final class VeganOptionButton: UIButton {
    private let spacing: CGFloat = 32

    var changedColor: UIColor?

    private var change = false

    // MARK: selected 분기 처리
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? changedColor : .gray6
            self.tintColor = isSelected ? .gray7 : .gray2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Button Attribute
    private func attribute() {
        backgroundColor = .gray6
    
        layer.cornerRadius = 10
    }
    
    // MARK: set button size
    // 폰 마다 버튼의 width을 다르게 하기 위한 조치
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !change {
            change = !change
            setButtonSize()
            verticalTitleToImage()
        }
    }
    
    // MARK: SetUp Button
    func setButton(_ title: String, _ image: UIImage) {
        let image = image.withRenderingMode(.alwaysTemplate)
        
        setImage(image, for: .normal)
        
        let attributedString = NSMutableAttributedString(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: UIColor.gray3 ?? .systemGray3,
                                      range: NSRange(location: 0, length: attributedString.length)
        )
        
        setAttributedTitle(attributedString, for: .normal)
        
        let attributedStringSelected = NSMutableAttributedString(string: title)
        attributedStringSelected.addAttribute(NSAttributedString.Key.paragraphStyle,
                                              value: paragraphStyle,
                                              range: NSRange(location: 0, length: attributedStringSelected.length)
        )
        attributedStringSelected.addAttribute(NSAttributedString.Key.foregroundColor,
                                              value: UIColor.gray7 ?? .white,
                                              range: NSRange(location: 0, length: attributedStringSelected.length)
        )
        
        setAttributedTitle(attributedStringSelected, for: .selected)

        titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel?.numberOfLines = 2
        
        tintColor = .gray2
    }
    
    // MARK: Vertical Title -> Image
    private func verticalTitleToImage() {
        let titleHeight = titleLabel?.frame.height ?? 0
        let titleWidth = titleLabel?.frame.width ?? 0
        
        let imageHeight = imageView?.frame.height ?? 0
        let imageWidth = imageView?.frame.width ?? 0
        
        titleEdgeInsets = UIEdgeInsets(
            top: -(imageHeight + spacing),
            left: -imageWidth,
            bottom: 0.0,
            right: 0.0
        )
        
        imageEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: -(titleHeight + spacing),
            right: -(self.frame.width)
        )
    }
    
    // MARK: button 높이 & 넓이 설정
    private func setButtonSize() {
        let depth: CGFloat = 20.0

        let superViewWitdh: CGFloat = Double(self.superview?.frame.width ?? 0)

        let buttonWidth = (superViewWitdh - depth) / 3
        self.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        // image Height + title Height + spacing + padding
        let imageHeight = imageView?.frame.height ?? 0
        let titleHeight = titleLabel?.frame.height ?? 0
        let padding: CGFloat = 24
        
        let totalHeight = imageHeight + titleHeight + padding + spacing

        self.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
}
