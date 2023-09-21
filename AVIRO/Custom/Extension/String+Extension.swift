//
//  String.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/17.
//

import UIKit

extension String {
    // MARK: Nickname 갯수 제한 8개
    var limitedNickname: String {
        if self.count > 8 {
            let startIndex = self.startIndex
            let endIndex = self.index(startIndex, offsetBy: 7)
            return String(self[startIndex...endIndex])
        }
        return self
    }
    
    // MARK: Text m/k 변환
    /// Text m/k 변환
    func convertDistanceUnit() -> String {
        guard let number = Double(self) else { return "" }
        
        if number >= 1000 {
            return String(format: "%.1fkm", number / 1000) 
        } else {
            return "\(Int(number))m"
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
            return numberFormatter.string(
                from: NSNumber(value: number)
            )
        }
        return self
    }

    // MARK: Text 색상 변경
    func changeColor(changedText: String) -> NSMutableAttributedString? {
        if let range = self.range(of: changedText, options: []) {
            let attributedText = NSMutableAttributedString(string: self)
            attributedText.addAttribute(
                .foregroundColor, 
                value: UIColor.keywordBlue,
                range: NSRange(range, in: self)
            )
            
            return attributedText
        }
        return nil
    }
}
