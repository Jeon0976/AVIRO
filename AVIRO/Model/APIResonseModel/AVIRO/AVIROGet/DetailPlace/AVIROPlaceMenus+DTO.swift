//
//  AVIROMenuResultDTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/21.
//

import Foundation

struct AVIROMenusResultDTO: Decodable {
    let statusCode: Int
    let data: AVIROPlaceMenus
}

struct AVIROPlaceMenus: Decodable {
    let count: Int
    let updatedTime: String
    let menuArray: [AVIROMenu]
}
