//
//  AVIROReviewsModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/21.
//

import Foundation

struct AVIROReviewsModelDTO: Decodable {
    let statusCode: Int
    let data: AVIROReviewsModelArrayDTO
}

struct AVIROReviewsModelArrayDTO: Decodable {
    let commentArray: [AVIROReviewRawDataDTO]
}

struct AVIROReviewRawDataDTO: Codable {
    var commentId: String
    var userId: String
    var content: String
    var updatedTime: String
    // TODO: Nickname 수정 후 수정
    var nickname: String?
}
