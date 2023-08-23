//
//  BookmarkPostModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/23.
//

import Foundation

struct BookmarkPostModel: Encodable {
    let placeList: [String]
    let userId: String
}

struct BookmarkPostAfterData: Decodable {
    let statusCode: Int
}
