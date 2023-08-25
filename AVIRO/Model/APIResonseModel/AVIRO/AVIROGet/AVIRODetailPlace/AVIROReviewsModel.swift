//
//  AVIROReviewsModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/21.
//

import Foundation

struct AVIROReviewsModel: Decodable {
    let statusCode: Int
    let data: PlaceReviewsData
}

struct PlaceReviewsData: Decodable {
    let commentArray: [ReviewData]
}

struct ReviewData: Codable {
    var commentId: String
    var userId: String
    var content: String
    var updatedTime: String
    var nickname: String?
}
