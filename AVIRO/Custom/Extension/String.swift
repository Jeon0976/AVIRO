//
//  String.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/17.
//

import Foundation

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
    
    // MARK: 숫자 변형
    // TODO: 숫자가 아닌 값 입력할 때를 여기서 처리??
    // 취소 예정
    func currenyKR() -> String {
        guard let price = Int(self) else {
            return "0"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: NSNumber(value: price)) ?? ""
    }
    
    // MARK: 자동 ',' 찍기
    /// decimal string 변환
    func formatNumber() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = .current
        print(self)
        
        let noCommaString = self.replacingOccurrences(of: ",", with: "")
        
        if let number = Int(noCommaString) {
            return numberFormatter.string(from: NSNumber(value: number))
        }
        return self
    }

}
