//
//  AVIROPlaceInfoResultDTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/21.
//

struct AVIROPlaceInfoResultDTO: Decodable {
    let statusCode: Int
    let data: AVIROPlaceInfo
}

struct AVIROPlaceInfo: Decodable {
    let placeId: String
    let address: String
    let address2: String?
    let phone: String?
    let url: String?
    let haveTime: Bool
    let shopStatus: String
    let shopHours: String
    let updatedTime: String
}
