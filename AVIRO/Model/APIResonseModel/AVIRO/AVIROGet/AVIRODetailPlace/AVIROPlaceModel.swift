//
//  AVIROPlaceModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/21.
//

import Foundation

struct AVIROPlaceModel: Decodable {
    let statusCode: Int
    let data: PlaceInfoData
}

struct PlaceInfoData: Decodable {
    let placeId: String
    let address: String
    let phone: String?
    let url: String?
    let shopStatus: String
    let shopHours: String
    let updatedTime: String
}
