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
    static func nowDateTime() -> String {
        let date = Date()
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            
            return dateFormatter
        }()

        let dateTime = dateFormatter.string(from: date)
        
        return dateTime
    }
}
