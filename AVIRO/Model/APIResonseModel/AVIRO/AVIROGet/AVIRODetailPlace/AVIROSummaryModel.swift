//
//  AVIROSummaryModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/21.
//

import Foundation

struct AVIROSummaryModel: Decodable {
    let statusCode: Int
    let data: PlaceSummaryData
}

struct PlaceSummaryData: Decodable {
    let placeId: String
    let title: String
    let category: String
    let address: String
    let commentCount: Int
}
