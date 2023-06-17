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
}
