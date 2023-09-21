//
//  AVIROSummaryModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/21.
//

struct AVIROSummaryResultDTO: Decodable {
    let statusCode: Int
    let data: AVIROPlaceSummary
}

struct AVIROPlaceSummary: Decodable {
    let placeId: String
    let title: String
    let category: String
    let address: String
    let commentCount: Int
}
