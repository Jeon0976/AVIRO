//
//  AVIROCommentModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/21.
//

import Foundation

struct AVIROCommentModel: Decodable {
    let status: Int
    let data: [CommentArray]
}

struct CommentArray: Codable {
    var commentId: String
    var userId: String
    var content: String
    var createdTime: String
}
