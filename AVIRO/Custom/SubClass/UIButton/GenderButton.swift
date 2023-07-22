//
//  GenderButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/12.
//

import UIKit

final class GenderButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title = title else {
            super.setTitle(title, for: state)
            return
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.subTitle ?? .lightGray
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        
        setAttributedTitle(attributedTitle, for: state)

        // selected title
        let selectedAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.white
        ]
        
        let selectedAttributedTitle = NSAttributedString(string: title, attributes: selectedAttribute)

        setAttributedTitle(selectedAttributedTitle, for: .selected)
    }
    
    // MARK: Set Width
    // 폰 마다 버튼의 Width을 다르게 하기 위한 조치
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let depth = 20.0
        let viewWidth = Double(self.superview?.frame.width ?? 0)
        let buttonWidth = (viewWidth - depth) / 3.0
        self.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
    }
    
    private func setupButton() {
        self.backgroundColor = .backField
        self.layer.cornerRadius = 26
        self.contentEdgeInsets = UIEdgeInsets(top: 16, left: 35, bottom: 16, right: 35)
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .allVegan : .backField
        }
    }
}
