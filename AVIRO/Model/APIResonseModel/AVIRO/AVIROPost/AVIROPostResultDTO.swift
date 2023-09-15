//
//  AVIROPostResultDTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/15.
//

import Foundation

// MARK: Output Data
struct AVIROPostResultDTO: Decodable {
    let statusCode: Int
    let message: String?
}
