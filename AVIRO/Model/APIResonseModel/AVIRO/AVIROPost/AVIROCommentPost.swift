//
//  AVIROComment.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/27.
//

import Foundation

struct AVIROCommentPost: Encodable {
    let commentId = UUID().uuidString
    let placeId: String
    let userId: String
    let content: String
}
