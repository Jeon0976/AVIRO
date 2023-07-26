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
    
    // MARK: set Width
    // 폰 마다 버튼의 width을 다르게 하기 위한 조치
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
    
    // MARK: SetUp Button
    func setButton(_ title: String, _ image: UIImage) {
        let image = image.withRenderingMode(.alwaysTemplate)
        
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        
        setTitleColor(.gray3, for: .normal)
        setTitleColor(.gray7, for: .selected)
        
        titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel?.numberOfLines = 2
        tintColor = .gray2
        
        verticalTitleToImage()
    }
    
    // MARK: Vertical Title -> Image
    func verticalTitleToImage() {
        // title size width 74 height 39
        // image size width 40 height 40
        let titleHeight: CGFloat = 40
        let titleWidth: CGFloat = 74
        
        let imageHeight: CGFloat = 40
        let imageWidth: CGFloat = 40
        
        let totalHeight = imageHeight + titleHeight + spacing

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
            right: -titleWidth + (-titleWidth / 2)
        )
        
//        let depth: CGFloat = 20.0
//
//        let superViewWitdh: CGFloat = Double(self.superview?.frame.width ?? 0)
//
//        let buttonWidth = (superViewWitdh - depth) / 3
//
//        self.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
//
//        // image Height + title Height + spaing + padding
//        let buttonHeight = totalHeight + 24
//        self.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
}
