//
//  PlaceListCellModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

/// PlaceListCell에 뿌려질 데이터
struct PlaceListCellModel: Codable {
    let title: String
    let address: String
    let distance: String
}
