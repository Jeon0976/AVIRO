//
//  VeganModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//
//
import Foundation

// MARK: Input Data
/// 사용자가 입력한 데이터
/// 옵셔널 데이터는 검색으로 입력, 좌표로 입력에 따라 값이 있고 없을 수 있기 때문
struct AVIROEnrollPlaceDTO: Codable {
    var placeId = UUID().uuidString
    var userId: String
    var title: String
    var category: String
    var address: String
    var phone: String
    var x: Double
    var y: Double
    
    var allVegan: Bool
    var someMenuVegan: Bool
    var ifRequestVegan: Bool
    
    var menuArray: [AVIROMenu]?
}
