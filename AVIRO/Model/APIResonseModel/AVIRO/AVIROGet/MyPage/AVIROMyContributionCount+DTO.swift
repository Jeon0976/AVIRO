//
//  AVIROMyContributionCount+DTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/21.
//

import Foundation

struct AVIROMyContributionCountDTO: Decodable {
    let statusCode: Int
    let data: AVIROMyActivityCounts?
    let message: String?
}

struct AVIROMyActivityCounts: Decodable {
    let placeCount: Int
    let commentCount: Int
    let bookmarkCount: Int
}
