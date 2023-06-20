//
//  VeganTableFieldModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/20.
//

import Foundation

struct VeganTableFieldModel {
    var menu: String
    var price: String
    
    var hasData: Bool {
        return !menu.isEmpty && !price.isEmpty
    }
}
