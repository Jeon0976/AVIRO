//
//  PlaceListModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

struct PlaceListModel: Codable, Equatable {
    static func == (lhs: PlaceListModel, rhs: PlaceListModel) -> Bool {
        return lhs.title == rhs.title
    }

    var title: String
    var distance: String
    var address: String
    var phone: String
    let x: Double
    let y: Double
}
