//
//  CommentPostModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//

import Foundation

struct CommentPostModel: Codable {
    var commentId: String
    var placeId: String
    var userId: String
    var comment: String
}
