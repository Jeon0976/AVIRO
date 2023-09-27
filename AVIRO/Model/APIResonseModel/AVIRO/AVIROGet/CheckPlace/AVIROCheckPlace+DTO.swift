//
//  AVIROCheckPlace.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/01.
//

import Foundation

struct AVIROCheckPlaceDTO: Encodable {
    let title: String
    let address: String
    let x: String
    let y: String
}

struct AVIROCheckPlaceResultDTO: Decodable {
    let statusCode: Int
    let registered: Bool
    let message: String?
}
