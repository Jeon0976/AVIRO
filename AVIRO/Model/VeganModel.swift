//
//  VeganModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//
//
import Foundation

/// 사용자가 입력한 데이터
/// 옵셔널 데이터는 검색으로 입력, 좌표로 입력에 따라 값이 있고 없을 수 있기 때문
struct VeganModel {
    let coordinate: VeganModelCoordinate
    let metaData: VeganModelMetaData
    // plus data

    // user input data 3단계 logic
    let onlyVegan: Bool
    let someMenuVegan: Bool
    let ifRquestPossibleVegan: Bool

    // request

}

/// coordinate data
struct VeganModelCoordinate {
    let longitude: Double
    let latitude: Double
}

/// meta data
struct VeganModelMetaData {
    let title: String
    let address: String?
    let category: String?
    let url: String?
    let phone: String?
}

/// plus data
struct VeganModelPlusData {
}
