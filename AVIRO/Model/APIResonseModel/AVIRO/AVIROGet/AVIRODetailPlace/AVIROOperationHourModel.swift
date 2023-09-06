//
//  AVIROOperationHourModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/06.
//

import Foundation

struct AVIROOperationHourModel: Decodable {
    let statusCode: Int
    let data: AVIROOperationHoursData
}

struct AVIROOperationHoursData: Decodable {
    let mon: AVIROOperationHoursRawData
    let tue: AVIROOperationHoursRawData
    let wed: AVIROOperationHoursRawData
    let thu: AVIROOperationHoursRawData
    let fri: AVIROOperationHoursRawData
    let sat: AVIROOperationHoursRawData
    let sun: AVIROOperationHoursRawData
}

struct AVIROOperationHoursRawData: Decodable {
    let today: Bool
    let operation: String
    let breakTime: String
    
    enum CodingKeys: String, CodingKey {
        case today = "today"
        case operation = "open"
        case breakTime = "break"
    }
}

extension AVIROOperationHoursData {
    func toEditOperationHoursModels() -> [EditOperationHoursModel] {
        return [
                    EditOperationHoursModel(day: "월요일", operatingHours: mon.operation, breakTime: mon.breakTime),
                    EditOperationHoursModel(day: "화요일", operatingHours: tue.operation, breakTime: tue.breakTime),
                    EditOperationHoursModel(day: "수요일", operatingHours: wed.operation, breakTime: wed.breakTime),
                    EditOperationHoursModel(day: "목요일", operatingHours: thu.operation, breakTime: thu.breakTime),
                    EditOperationHoursModel(day: "금요일", operatingHours: fri.operation, breakTime: fri.breakTime),
                    EditOperationHoursModel(day: "토요일", operatingHours: sat.operation, breakTime: sat.breakTime),
                    EditOperationHoursModel(day: "일요일", operatingHours: sun.operation, breakTime: sun.breakTime)
                ]
    }
}
