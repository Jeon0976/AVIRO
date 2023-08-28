//
//  KakaoMapResponseAddressModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/28.
//

import Foundation

struct KakaoMapResponseAddressModel: Decodable {
    var documents: [CoordinateModel]?
}

struct CoordinateModel: Decodable {
    let x: String?
    let y: String?
}
