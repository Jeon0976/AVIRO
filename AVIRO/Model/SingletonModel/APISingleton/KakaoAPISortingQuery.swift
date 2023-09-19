//
//  KakaoAPISortingQuery.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/07.
//

import Foundation
 
enum KakaoSerachCoordinate {
    case MyCoordinate
    case CenterCoordinate
    
    var value: String {
        switch self {
        case .MyCoordinate:
            return "내위치중심"
        case .CenterCoordinate:
            return "지도중심"
        }
    }
}

enum KakaoSearchHowToSort {
    case distance
    case accuracy
    
    var value: String {
        switch self {
        case .distance:
            return "거리순"
        case .accuracy:
            return "정확도순"
        }
    }
}

final class KakaoAPISortingQuery {
    static let shared = KakaoAPISortingQuery()
    
    var coordinate = KakaoSerachCoordinate.MyCoordinate
    var sorting = KakaoSearchHowToSort.accuracy
    
    private init() { }
}
