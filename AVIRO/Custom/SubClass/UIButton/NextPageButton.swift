//
//  TutorialResButton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/08.
//

import UIKit

// Enable 일때 설정 다시
final class NextPageButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title = title else {
            super.setTitle(title, for: state)
            return
        }
        
        let enabledAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(size: 18, weight: .semibold),
            .foregroundColor: UIColor.gray7
        ]
        
        let disenabledAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(size: 18, weight: .semibold),
            .foregroundColor: UIColor.gray2
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: enabledAttributes)
        
        let disAttributedTitle = NSAttributedString(string: title, attributes: disenabledAttributes)
        
        setAttributedTitle(attributedTitle, for: state)
        setAttributedTitle(disAttributedTitle, for: .disabled)
    }
    
    private func setupButton() {
        self.layer.cornerRadius = 25
        self.contentEdgeInsets = UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25)
        self.clipsToBounds = true
        self.backgroundColor = .main
    }
     
    override var isEnabled: Bool {
         didSet {
             self.backgroundColor = isEnabled ? .main : .gray5
         }
     }
 }
