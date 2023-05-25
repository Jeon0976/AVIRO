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
    var placeModel: PlaceListModel
    var allVegan: Bool
    var someMenuVegan: Bool
    var ifRequestVegan: Bool
    
    var notRequestMenuArray: [NotRequestMenu]?
    var requestMenuArray: [RequestMenu]?
    
}

struct NotRequestMenu {
    var menu: String
    var price: String
    
    var hasData: Bool {
        return !menu.isEmpty && !price.isEmpty
    }
}

struct RequestMenu {
    var menu: String
    var price: String
    var howToRequest: String
    var isCheck: Bool
    
    var hasData: Bool {
        return !menu.isEmpty && !price.isEmpty && !howToRequest.isEmpty
    }
}
