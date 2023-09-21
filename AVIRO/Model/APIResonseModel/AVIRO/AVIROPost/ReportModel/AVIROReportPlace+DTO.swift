//
//  AVIROPlaceReportDTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/10.
//

import Foundation

struct AVIROReportPlaceDTO: Encodable {
    let placeId: String
    let userId: String
    let nickname: String
    let code: Int
}
