//
//  AVIROMenuModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/21.
//

import Foundation

struct AVIROMenuModel: Decodable {
    let statusCode: Int
    let data: AVIROMenuData
}

struct AVIROMenuData: Decodable {
    let menuArray: [MenuArray]
}
