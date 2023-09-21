//
//  UIButton+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/13.
//

import UIKit

extension UIButton {
    func countCurrentLines() -> Int {
        guard let text = self.titleLabel?.text else { return 0 }
        
        let rect = CGSize(
            width: self.bounds.width,
            height: CGFloat.greatestFiniteMagnitude
        )
        
        let labelSize = text.boundingRect(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes: [
                NSAttributedString.Key.font: titleLabel?.font ?? CFont.font.medium16
            ],
            context: nil
        )
        
        let numberOfLine = Int(
            ceil(
                CGFloat(labelSize.height)
                /
                (titleLabel?.font?.lineHeight ?? 1)
            )
        )
        
        return numberOfLine
    }
}
