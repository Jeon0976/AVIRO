//
//  AVIROComment.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/27.
//

import Foundation

struct AVIROEnrollCommentDTO: Encodable {
    var commentId = UUID().uuidString
    let placeId: String
    let userId: String
    let content: String
}

struct AVIROEditCommentDTO: Encodable {
    let commentId: String
    let content: String
    let userId: String
}

struct AVIRODeleteCommentDTO: Encodable {
    let commentId: String
    let userId: String
}