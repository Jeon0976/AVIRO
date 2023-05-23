//
//  PlaceListCellModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

/// API 요청 후 받고 나서 생기는 근간이 되는 데이터
struct PlaceListModel {
    let title: String
    let distance: String
    let category: String
    let address: String
    let phone: String
    let url: String
    let x: Double
    let y: Double
}
