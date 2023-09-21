//
//  AVIROReportReviewDTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/18.
//

import Foundation

struct AVIROReportReviewDTO: Encodable {
    let commentId: String
    let title: String
    let createdTime: String
    let commentContent: String
    let commentNickname: String
    let userId: String
    let nickname: String
    let code: Int
    let content: String
}
