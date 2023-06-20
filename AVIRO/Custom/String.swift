//
//  String.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/17.
//

import Foundation

extension String {
    // MARK: Text m/k 변환
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
    func currenyKR() -> String {
        guard let price = Int(self) else {
            return "0"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: NSNumber(value: price)) ?? ""
    }
}

