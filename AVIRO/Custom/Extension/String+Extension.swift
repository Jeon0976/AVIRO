//
//  String.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/17.
//

import UIKit

extension String {
    // MARK: Text m/k 변환
    /// Text m/k 변환
    func convertDistanceUnit() -> String {
        guard let number = Int(self) else { return "" }
        
        if number >= 1000 {
            return "\(number / 1000)k"
        } else {
            return "\(number)m"
        }
    }
    
    // MARK: 자동 ',' 찍기
    /// decimal string 변환
    func formatNumber() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = .current
        
        let noCommaString = self.replacingOccurrences(of: ",", with: "")
        
        if let number = Int(noCommaString) {
            return numberFormatter.string(from: NSNumber(value: number))
        }
        return self
    }

    // MARK: Text 색상 변경
    func changeColor(changedText: String) -> NSMutableAttributedString? {
        if let range = self.range(of: changedText, options: []) {
            let attributedText = NSMutableAttributedString(string: self)
            attributedText.addAttribute(.foregroundColor, value: UIColor.main, range: NSRange(range, in: self))
            return attributedText
        }
        return nil
    }
}
