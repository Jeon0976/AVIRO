//
//  KakaoMapResponseModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

struct KakaoMapResponseModel: Decodable {
    let mata: KakaoMapResponseMetaData
    let documents: [KakaoMapResponseRestaurantsAndCafes]
}

struct KakaoMapResponseMetaData: Decodable {
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case isEnd
    }
}

struct KakaoMapResponseRestaurantsAndCafes: Decodable {
    let documents: [RestaurantsAndCafes]
}

struct RestaurantsAndCafes: Decodable {
    let name: String
    let category: String
    let address: String
    let phone: String
    let url: String
    let xToLongitude: String
    let yToLatitude: String
    
    enum CodingKeys: String, CodingKey {
        case name = "place_name"
        case category = "category_name"
        case address = "road_address_name"
        case phone
        case url = "place_url"
        case xToLongitude = "x"
        case yToLatitude = "y"
    }
}
