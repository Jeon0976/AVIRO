//
//  AVIROMenuModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/21.
//

import Foundation

struct AVIROMenuModel: Decodable {
    let statusCode: Int
    let data: PlaceMenuData
}

struct PlaceMenuData: Decodable {
    let count: Int
    let updatedTime: String
    let menuArray: [MenuArray]
}
