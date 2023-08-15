//
//  PlaceListCellModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

/// API 요청 후 받고 나서 생기는 근간이 되는 데이터
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
