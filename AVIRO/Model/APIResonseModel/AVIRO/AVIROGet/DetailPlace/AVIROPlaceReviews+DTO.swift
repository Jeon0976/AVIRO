//
//  AVIROReviewsModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/21.
//

import Foundation

struct AVIROReviewsResultDTO: Decodable {
    let statusCode: Int
    let data: AVIROReviewsArray
}

struct AVIROReviewsArray: Decodable {
    let commentArray: [AVIROReviewRawData]
}

struct AVIROReviewRawData: Codable {
    var commentId: String
    var userId: String
    var content: String
    var updatedTime: String
    // TODO: Nickname 수정 후 수정
    var nickname: String?
}
