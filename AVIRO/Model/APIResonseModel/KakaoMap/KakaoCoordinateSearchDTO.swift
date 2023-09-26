//
//  KakaoCoordinateSearchDTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import Foundation

struct KakaoCoordinateSearchDTO {
    let lng: String
    let lat: String
}

struct KakaoCoordinateSearchResultDTO: Decodable {
    var documents: [KakaoCoordinatePlaceMetaData]?
}

struct KakaoCoordinatePlaceMetaData: Decodable {
    let address: KakaoRodeAdress?
    
    enum CodingKeys: String, CodingKey {
        case address = "road_address"
    }
}

struct KakaoRodeAdress: Decodable {
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case address = "address_name"
    }
}
