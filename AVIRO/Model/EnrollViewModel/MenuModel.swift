//
//  MenuModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/20.
//

import Foundation

struct AVIROMenu: Codable {
    var menuId = UUID().uuidString
    var menuType: String
    var menu: String
    var price: String
    var howToRequest: String
    var isCheck: Bool
}
