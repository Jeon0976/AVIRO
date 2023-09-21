//
//  KakaoMapResponseCoordinateModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import Foundation

// MARK: Coordinate & Address Place 작동 방식 다시 확인 필요
// TODO: 3 
struct KakaoCoordinatePlaceDTO: Decodable {
    var documents: [KakaoCoordinatePlaceMetaDataDTO]?
}

struct KakaoCoordinatePlaceMetaDataDTO: Decodable {
    let address: KakaoRodeAdressDTO?
    
    enum CodingKeys: String, CodingKey {
        case address = "road_address"
    }
}

struct KakaoRodeAdressDTO: Decodable {
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case address = "address_name"
    }
}
