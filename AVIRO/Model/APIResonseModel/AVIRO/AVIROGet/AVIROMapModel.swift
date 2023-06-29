//
//  AVIROMapModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/20.
//

import Foundation

struct AVIROMapModel: Decodable {
    let statusCode: Int
    let data: MapData
}

struct MapData: Decodable {
    let amount: Int
    let placeData: [HomeMapData]
}
