//
//  UILabel+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/18.
//

import UIKit

extension UILabel {
    func replaceEllipsis(with string: String) {
        guard let text = self.text else { return }
        
        lineBreakMode = .byClipping
        
        if numberOfLine(for: text) <= self.numberOfLines {
            return
        }
        
        let stringArray = self.text?.components(separatedBy: "\n")
        
        var numberOfLines: Int = 0
        var index: Int = 0
        
        while !(numberOfLines >= self.numberOfLines) {
            guard let string = stringArray?[index] else { break }

            let numberOfLine = numberOfLine(for: string)
            numberOfLines += numberOfLine

            if !(numberOfLines >= self.numberOfLines) { index += 1 }
        }
        
        guard let last = stringArray?[index] else { return }

        var result = (stringArray?[0..<index].joined(separator: "\n"))! + "\n" + last
        while !(numberOfLine(for: result + string) == self.numberOfLines) {
            result.removeLast()
        }
        
        result += string

        self.text = result
        self.sizeToFit()
    }
    
    fileprivate func numberOfLine(for text: String) -> Int {
        guard let font = self.font, text.count != 0 else { return 0 }
        
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = text.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let numberOfLine = Int(ceil(CGFloat(labelSize.height) / font.lineHeight ))
        
        return numberOfLine
    }
}
