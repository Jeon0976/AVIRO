//
//  AVIROPlaceReportDTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/10.
//

import Foundation

enum AVIROPlaceReportEnum: String {
    case noPlace = "없어짐"
    case noVegan = "비건없음"
    case dubplicatedPlace = "중복등록"
}

struct AVIROReportPlaceDTO: Encodable {
    let placeId: String
    let userId: String
    let nickname: String
    let content: AVIROPlaceReportEnum.RawValue
}
