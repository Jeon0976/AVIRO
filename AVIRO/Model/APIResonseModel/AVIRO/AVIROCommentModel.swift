//
//  AVIROCommentModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/21.
//

import Foundation

struct AVIROCommentModel: Decodable {
    let status: Int
    let data: CommentData
}

struct CommentData: Decodable {
    let commentArray: [CommentArray]
}

struct CommentArray: Codable {
    var userId: String
    var comment: String
    var createdTime: String
}
