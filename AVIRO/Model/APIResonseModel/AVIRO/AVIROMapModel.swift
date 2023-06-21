//
//  AVIROMapModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/20.
//

import Foundation

struct AVIROMapModel: Decodable {
    let status: Int
    let data: mapData
}

struct mapData: Decodable {
    let amount: Int
    let placeData: [HomeMapData]
}
