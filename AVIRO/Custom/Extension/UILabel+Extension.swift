//
//  UILabel+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/18.
//

import UIKit

extension UILabel {
    func countCurrentLines() -> Int {
        guard let text = self.text else { return 0 }
        
        let rect = CGSize(
            width: self.bounds.width,
            height: CGFloat.greatestFiniteMagnitude
        )
        
        let labelSize = text.boundingRect(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes: [
                NSAttributedString.Key.font: font ?? CFont.font.medium16],
            context: nil
        )
        
        let numberOfLine = Int(ceil(CGFloat(labelSize.height) / font.lineHeight ))
        
        return numberOfLine
    }
}
