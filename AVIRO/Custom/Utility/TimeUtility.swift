//
//  TimeUtility.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import Foundation

final class TimeUtility {
    /// 현재 날짜만 불러오기 "yyyy.MM.dd"
    static func nowDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
    
    /// 현재 날짜 & 시간 불러오기 "yyyy-MM-dd 00:00:00"
    static func nowDateAndTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"

        let formattedDateTime = formatter.string(from: date)
        
        return formattedDateTime
    }
    
    /// 날짜 유효성 검사
    static func isValidDate(_ birth: String) -> Bool {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        if let date = dateFormatter.date(from: birth) {
            let calender = Calendar.current
            let year = calender.component(.year, from: date)
            let month = calender.component(.month, from: date)
            let day = calender.component(.day, from: date)
            
            let currentYear = calender.component(.year, from: Date())
            
            if year > currentYear || year < 1920 || month < 1 || month > 12 || day < 1 || day > 31 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}
