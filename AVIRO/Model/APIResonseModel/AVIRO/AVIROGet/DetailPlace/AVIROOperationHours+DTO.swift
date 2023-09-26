//
//  AVIROOperationHourModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/06.
//

import Foundation

struct AVIROOperationHoursDTO: Decodable {
    let statusCode: Int
    let data: AVIROOperationWeek
}

struct AVIROOperationWeek: Decodable {
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

extension AVIROOperationWeek {
    func toEditOperationHoursModels() -> [EditOperationHoursModel] {
        return [
            EditOperationHoursModel(
                day: Day.mon,
                operatingHours: mon.operation,
                breakTime: mon.breakTime,
                isToday: mon.today
            ),
            EditOperationHoursModel(
                day: Day.tue,
                operatingHours: tue.operation,
                breakTime: tue.breakTime,
                isToday: tue.today
            ),
            EditOperationHoursModel(
                day: Day.wed,
                operatingHours: wed.operation,
                breakTime: wed.breakTime,
                isToday: wed.today
            ),
            EditOperationHoursModel(
                day: Day.thu,
                operatingHours: thu.operation,
                breakTime: thu.breakTime,
                isToday: thu.today
            ),
            EditOperationHoursModel(
                day: Day.fri,
                operatingHours: fri.operation,
                breakTime: fri.breakTime,
                isToday: fri.today
            ),
            EditOperationHoursModel(
                day: Day.sat,
                operatingHours: sat.operation,
                breakTime: sat.breakTime,
                isToday: sat.today
            ),
            EditOperationHoursModel(
                day: Day.sun,
                operatingHours: sun.operation,
                breakTime: sun.breakTime,
                isToday: sun.today
            )
        ]
    }
}
