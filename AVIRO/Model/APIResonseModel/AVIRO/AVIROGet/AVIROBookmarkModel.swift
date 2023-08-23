//
//  AVIROBookmarkModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/23.
//

import Foundation

struct AVIROBookmarkModel: Decodable {
    let statusCode: Int
    let bookmarks: [String]
}
