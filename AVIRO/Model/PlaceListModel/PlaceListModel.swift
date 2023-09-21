//
//  PlaceListModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

// MARK: 코드 확인 후 DTO 처리할지 고민
// TODO: 1,2,3 전부다
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
