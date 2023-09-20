//
//  AVIROPlaceReportDTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/10.
//

import Foundation

enum AVIROReportPlaceEnum: String {
    case noPlace = "없어짐"
    case noVegan = "비건없음"
    case dubplicatedPlace = "중복등록"
    
    var code: Int {
        switch self {
        case .noPlace:
            return 1
        case .noVegan:
            return 2
        case .dubplicatedPlace:
            return 3
        }
    }
}

struct AVIROReportPlaceDTO: Encodable {
    let placeId: String
    let userId: String
    let nickname: String
    let code: Int
}
