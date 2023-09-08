//
//  AVIROComment.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/27.
//

import Foundation

struct AVIROCommentPost: Encodable {
    var commentId = UUID().uuidString
    let placeId: String
    let userId: String
    let content: String
}

struct AVIROEditCommentPost: Encodable {
    let commentId: String
    let content: String
    let userId: String
}

struct AVIRODeleteCommentPost: Encodable {
    let commentId: String
    let userId: String
}
