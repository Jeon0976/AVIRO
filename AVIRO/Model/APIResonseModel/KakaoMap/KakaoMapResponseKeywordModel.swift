//
//  KakaoMapResponseModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

struct KakaoMapResponseKeywordModel: Decodable {
    let meta: KakaoMapResponseMetaData
    let documents: [PlaceDataFromKakao]
}

struct KakaoMapResponseMetaData: Decodable {
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
    }
}

struct PlaceDataFromKakao: Decodable {
    let name: String
    let address: String
    let phone: String
    let url: String
    let xToLongitude: String
    let yToLatitude: String
    let distance: String
    
    enum CodingKeys: String, CodingKey {
        case name = "place_name"
        case address = "road_address_name"
        case phone
        case url = "place_url"
        case xToLongitude = "x"
        case yToLatitude = "y"
        case distance
    }
}
