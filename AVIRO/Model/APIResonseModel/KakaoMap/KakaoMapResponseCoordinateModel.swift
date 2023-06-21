//
//  KakaoMapResponseCoordinateModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import Foundation

struct KakaoMapResponseCoordinateModel: Decodable {
    let documents: [AddressModel]
}

struct AddressModel: Decodable {
    let address: RodeAdress
    
    enum CodingKeys: String, CodingKey {
        case address = "road_address"
    }
}

struct RodeAdress: Decodable {
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case address = "address_name"
    }
}
