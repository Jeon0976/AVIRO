//
//  MenuTypeLabel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/17.
//

import UIKit

final class MenuTypeLabel: UILabel {
    private var topInset: CGFloat = 5.0
    private var bottomInset: CGFloat = 5.0
    private var leftInset: CGFloat = 8.0
    private var rightInset: CGFloat = 8.0
    
    var type: MenuType = .vegan {
        didSet {
            switch type {
            case .vegan:
                isVeganType()
            case .needToRequset:
                isNeedToRequestType()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    private func makeAttribute() {
        self.layer.cornerRadius = 12
        self.font = .systemFont(ofSize: 11, weight: .bold)
        self.layer.borderWidth = 1
    }
    
    private func isVeganType() {
        self.text = "비건"
        self.textColor = .all
        self.layer.borderColor = UIColor.all?.cgColor
    }
    
    private func isNeedToRequestType() {
        self.text = "요청시 비건"
        self.textColor = .request
        self.layer.borderColor = UIColor.request?.cgColor
    }
}
