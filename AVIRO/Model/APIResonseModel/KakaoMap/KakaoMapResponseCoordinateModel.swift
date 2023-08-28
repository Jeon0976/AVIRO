//
//  KakaoMapResponseCoordinateModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import Foundation

struct KakaoMapResponseCoordinateModel: Decodable {
    var documents: [AddressModel]?
}

struct AddressModel: Decodable {
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
