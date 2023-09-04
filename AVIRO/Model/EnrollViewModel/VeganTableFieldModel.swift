//
//  VeganTableFieldModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/20.
//

import Foundation

struct VeganTableFieldModel: Hashable {
    let id: UUID = UUID()
    var menu: String
    var price: String
}

struct VeganTableFieldModelForEdit: Equatable {
    var id: String
    var menu: String
    var price: String
}
