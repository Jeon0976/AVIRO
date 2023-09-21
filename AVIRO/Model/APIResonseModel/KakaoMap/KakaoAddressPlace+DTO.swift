//
//  KakaoMapResponseAddressModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/28.
//

import Foundation

struct KakaoAddressPlaceDTO: Decodable {
    var documents: [KakaoAddressPlaceMetaDataDTO]?
}

struct KakaoAddressPlaceMetaDataDTO: Decodable {
    let x: String?
    let y: String?
}
